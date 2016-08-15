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

  final Set<ActorAction> actions;
  int planConsequencesComputed = 0;
  bool _resultsReady = false;

  final Map<ActorAction, num> firstActionScores = new Map();

  ActorPlanner(Actor actor, WorldState initialWorld, this.actions)
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

  void plan({int maxOrder: 3}) {
    firstActionScores.clear();

    var currentActor =
        _initial.world.actors.singleWhere((a) => a.id == actorId);
    var initialScore = currentActor.scoreWorld(_initial.world);

    for (var action in actions) {
//      TODO: compute (simpler) 'other' plans for each other player...
//        - after each action.apply, we need to simulate other actors (var planner = new ActorPlanner(otherActor, world, actions);)
      var consequenceStats = _getConsequenceStats(_initial, action, maxOrder);

      if (consequenceStats.isEmpty) {
        // This action isn't even possible in [_initial.world].
        firstActionScores[action] = double.NEGATIVE_INFINITY;
        continue;
      }

      var score = combineScores(consequenceStats, initialScore);

      firstActionScores[action] = score;
    }

    _resultsReady = true;
  }

  /// Computes the combined score for a bunch of consequences.
  ///
  /// TODO: allow to personalize this (for example, optimistic characters
  /// only take `isSuccess == true` consequences into account).
  num combineScores(Iterable<ConsequenceStats> stats, num initialScore) {
    var uplifts = <num>[];

    ConsequenceStats _bestCase;

    for (var consequence in stats) {
      if (consequence.cumulativeProbability > bestCaseProbabilityThreshold) {
        if (_bestCase == null) {
          _bestCase = consequence;
        } else if (consequence.score > _bestCase.score) {
          _bestCase = consequence;
        }
      }

      var uplift = (consequence.score - initialScore) *
          consequence.cumulativeProbability;
      uplifts.add(uplift);
    }

    var average = uplifts.fold(0, (a, b) => a + b) / uplifts.length;
    var best = _bestCase == null ? 0 : _bestCase.score / _bestCase.order;

    return best + average;
  }

  /// Returns the stats for consequences of a given [initial] state after
  /// applying [firstAction] and then up to [maxOrder] other steps.
  Iterable<ConsequenceStats> _getConsequenceStats(
      PlanConsequence initial, ActorAction firstAction, int maxOrder) sync* {
    // Actor object changes during planning, so we need to look up via id.
    var currentActor = initial.world.actors.singleWhere((a) => a.id == actorId);

    var open = new Queue<PlanConsequence>();
    final closed = new Set<WorldState>();

    if (!firstAction.isApplicable(currentActor, initial.world)) {
      return;
    }

    var initialWorldHash = initial.world.hashCode;
    for (var firstConsequence
        in firstAction.apply(currentActor, initial, initial.world)) {
      if (initial.world.hashCode != initialWorldHash) {
        throw new StateError("Action ${firstAction} modified world state when "
            "producing $firstConsequence.");
      }
      open.add(firstConsequence);
    }

    while (open.isNotEmpty) {
      var current = open.removeFirst();

      if (current.order >= maxOrder) break;

      // Actor object changes during planning, so we need to look up via id.
      var currentActor =
          current.world.actors.singleWhere((a) => a.id == actorId);

      var score = currentActor.scoreWorld(current.world);
      yield new ConsequenceStats(
          score, current.cumulativeProbability, current.order);

      for (ActorAction action in actions) {
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
