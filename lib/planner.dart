library stranded.planner;

import 'dart:collection';

import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/plan_consequence.dart';
import 'package:stranded/world.dart';

class ActorPlanner {
  /// We will stop processing a plan path once its leaf node has lower
  /// cumulative probability than this.
  static const minimumCumulativeProbability = 0.05;

  /// Only consequences with cumulative probability over this threshold
  /// will be considered for best cases.
  static const num bestCaseProbabilityThreshold = 0.3;

  final int actorId;
  final PlanConsequence _initial;

  final List<ActorAction> actions;
  final List<ActionGenerator> actionGenerators;
  int planConsequencesComputed = 0;
  bool _resultsReady = false;

  final Map<ActorAction, num> firstActionScores = new Map();

  ActorPlanner(
      Actor actor, WorldState initialWorld, this.actions, this.actionGenerators)
      : actorId = actor.id,
        _initial = new PlanConsequence.initial(initialWorld);

  ActorAction getBest() {
    assert(_resultsReady);

    num bestScore = firstActionScores.values.reduce((a, b) => a > b ? a : b);

    for (var action in firstActionScores.keys) {
      if (firstActionScores[action] == bestScore) {
        return action;
      }
    }

    throw new StateError("No best action found in $firstActionScores "
        "(bestScore = $bestScore)");
  }

  Iterable<String> generateTable() sync* {
    int i = 0;
    for (var key in firstActionScores.keys) {
      yield "$i) $key\t${firstActionScores[key].toStringAsFixed(2)}";
      i += 1;
    }
  }

  Iterable<ActorAction> _generateAllActions(
      Actor actor, WorldState world) sync* {
    yield* actions;
    for (var generator in actionGenerators) {
      yield* generator.build(actor, world);
    }
  }

  void plan({int maxOrder: 3}) {
    firstActionScores.clear();

    var currentActor =
        _initial.world.actors.singleWhere((a) => a.id == actorId);
    var initialScore = currentActor.scoreWorld(_initial.world);

    for (var action in _generateAllActions(currentActor, _initial.world)) {
      if (!action.isApplicable(currentActor, _initial.world)) {
        // Bail early if action isn't possible at all.
        continue;
      }
      var consequenceStats = _getConsequenceStats(_initial, action, maxOrder)
          .toList(growable: false);

      if (consequenceStats.isEmpty) {
        // This action is possible but we couldn't get to any outcomes while
        // planning.
        firstActionScores[action] = double.NEGATIVE_INFINITY;
        continue;
      }

      var score = combineScores(consequenceStats, initialScore, maxOrder);

      firstActionScores[action] = score;
    }

    _resultsReady = true;
  }

  /// Computes the combined score for a bunch of consequences.
  ///
  /// TODO: allow to personalize this (for example, optimistic characters
  /// only take `isSuccess == true` consequences into account).
  num combineScores(
      Iterable<ConsequenceStats> stats, num initialScore, int maxOrder) {
    var list = stats
        .where((stat) => stat.order == maxOrder - 1)
        .toList(growable: false);
    return list
            .map((stat) =>
                (stat.score - initialScore) * stat.cumulativeProbability)
            .fold(0, (a, b) => a + b) /
        list.length;
//    var uplifts = <num>[];
//
//    ConsequenceStats _bestCase;
//
//    for (var consequence in stats) {
//      if (consequence.cumulativeProbability > bestCaseProbabilityThreshold) {
//        if (_bestCase == null) {
//          _bestCase = consequence;
//        } else if (consequence.score > _bestCase.score) {
//          _bestCase = consequence;
//        }
//      }
//
//      var uplift = (consequence.score - initialScore) *
//          consequence.cumulativeProbability;
//      uplifts.add(uplift);
//    }
//
//    var average = uplifts.fold(0, (a, b) => a + b) / uplifts.length;
//    var best = _bestCase == null ? 0 : _bestCase.score / _bestCase.order;
//
//    return best + average;
  }

  /// Returns the stats for consequences of a given [initial] state after
  /// applying [firstAction] and then up to [maxOrder] other steps.
  Iterable<ConsequenceStats> _getConsequenceStats(
      PlanConsequence initial, ActorAction firstAction, int maxOrder) sync* {
    // Actor object changes during planning, so we need to look up via id.
    var mainActor = initial.world.actors.singleWhere((a) => a.id == actorId);

    // DEBUG TODO: remove
    bool DEBUG = false;
    if (DEBUG && (firstAction as EnemyTargetAction).name.contains("Kick")) {
      print("INITIAL");
      print(
          "adding: score=${mainActor.scoreWorld(initial.world)} * cumProb=${initial
          .cumulativeProbability} (prob=${initial.probability}, ord=${initial
          .order})");
      print("${' ' * initial.order}- ${initial.action}");
      print("-----");
    }
    num initialScore = mainActor.scoreWorld(initial.world);

    Queue<PlanConsequence> open = new Queue<PlanConsequence>();
    final Set<WorldState> closed = new Set<WorldState>();

    if (!firstAction.isApplicable(mainActor, initial.world)) {
      return;
    }

    var initialWorldHash = initial.world.hashCode;
    for (var firstConsequence
        in firstAction.apply(mainActor, initial, initial.world)) {
      if (initial.world.hashCode != initialWorldHash) {
        throw new StateError("Action ${firstAction} modified world state when "
            "producing $firstConsequence.");
      }
      open.add(firstConsequence);
    }

    while (open.isNotEmpty) {
      var current = open.removeFirst();

      if (current.order >= maxOrder) break;
      if (current.world.situations.isEmpty) continue;

      var currentActor =
          current.world.currentSituation.state.getCurrentActor(current.world);
      assert(currentActor != null);

      // This actor is the one we originally started planning for.
      var mainActor = current.world.actors.singleWhere((a) => a.id == actorId);
      assert(mainActor != null);
      bool currentActorIsMain = currentActor == mainActor;

      if (currentActorIsMain) {
        var score = mainActor.scoreWorld(current.world);
        yield new ConsequenceStats(
            score, current.cumulativeProbability, current.order);
      }

      // DEBUG TODO: remove
      if (DEBUG && (firstAction as EnemyTargetAction).name.contains("Kick")) {
        var score = mainActor.scoreWorld(current.world);
        print("----");
        print(
            "SITUATION = ${current.world.currentSituation.state.runtimeType}");
        print("ACTOR = ${currentActor.name} ($currentActorIsMain)");
        print(
            "score=${score - initialScore} * cumProb=${current.cumulativeProbability} "
            "(prob=${current.probability}, ord=${current.order})");
        var ars = current.world.actionRecords.toList()
          ..sort((a, b) => a?.time?.compareTo(b?.time) ?? 1);
        print(ars.map((a) => a.description).join(' <- '));
        //${' ' * current.order}
        // ${current.action} |

      }

      for (ActorAction action
          in _generateAllActions(currentActor, current.world)) {
        if (!action.isApplicable(currentActor, current.world)) continue;
        var consequences = action.apply(currentActor, current, current.world);

        for (PlanConsequence next in consequences) {
          planConsequencesComputed++;

          // Ignore consequences that have a tiny probability of happening.
          var cumulativeProbability = next.cumulativeProbability;
          if (cumulativeProbability < minimumCumulativeProbability) {
            continue;
          }

          // Ignore consequences that have already been visited.
          if (closed.contains(next.world)) {
            continue;
          }

          open.add(next);
        }
      }

      closed.add(current.world);
    }
  }
}
