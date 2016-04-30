library stranded.planner;

import 'dart:collection';

import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/plan_consequence.dart';
import 'package:stranded/world.dart';

class ActorPlanner {
  /// We will stop processing a plan path once its leaf node has lower
  /// cumulative probability than this.
  static const minimumCumulativeProbability = 0.0;
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

    throw new StateError("No best action found in $firstActionScores");
  }

  void plan({int maxOrder: 3}) {
    firstActionScores.clear();

    var currentActor =
        _initial.world.actors.singleWhere((a) => a.id == actorId);
    var initialScore = currentActor.scoreWorld(_initial.world);

    for (var action in actions) {
      var consequences = _getConsequencesOfOrder(_initial, action, maxOrder);

      firstActionScores[action] = combineScores(consequences, initialScore);
    }

    _resultsReady = true;
  }

  /// Computes the combined score for a bunch of consequences.
  ///
  /// TODO: allow to personalize this (for example, optimistic characters
  /// only take `isSuccess == true` consequences into account).
  num combineScores(Iterable<PlanConsequence> consequences, num initialScore) {
    var uplifts = <num>[];

    for (var consequence in consequences.where((c) => c.isSuccess)) {
      var currentActor =
          consequence.world.actors.singleWhere((a) => a.id == actorId);
      var uplift = currentActor.scoreWorld(consequence.world) - initialScore;
      uplift *= consequence.cumulativeProbability;
      uplifts.add(uplift);
    }

//    int reverseOrder(num a, num b) => -a.compareTo(b);
//
//    uplifts.sort(reverseOrder);
//    uplifts = uplifts.take(100).toList(growable: false);

    return uplifts.fold(0, (a, b) => a + b) / uplifts.length;
  }

  /// Returns the consequences of a given [initial] state after applying
  /// [firstAction] and then [n] other steps.
  Set<PlanConsequence> _getConsequencesOfOrder(
      PlanConsequence initial, ActorAction firstAction, int n) {
    var currentActor = initial.world.actors.singleWhere((a) => a.id == actorId);

    var open = new Queue<PlanConsequence>();
    final closed = new Set<WorldState>();

    final results = new Set<PlanConsequence>();

    if (!firstAction.isApplicable(currentActor, initial.world)) {
      return new Set.identity();
    }

    var initialWorldCopy = new WorldState.from(initial.world);
    open.addAll(firstAction.apply(currentActor, initial, initialWorldCopy));

    while (open.isNotEmpty) {
      var current = open.removeFirst();

      if (current.order == n) {
        results.add(current);
        closed.add(current.world);
        continue;
      }

      if (current.order > n) break;

      // Actor object changes during planning, so we need to look up via id.
      var currentActor =
          current.world.actors.singleWhere((a) => a.id == actorId);

      bool hasConsequence = false;

      for (ActorAction action in actions) {
        if (!action.isApplicable(currentActor, current.world)) continue;
        var worldCopy = new WorldState.from(current.world);
        var consequences = action.apply(currentActor, current, worldCopy);
        for (PlanConsequence next in consequences) {
          hasConsequence = true;
          planConsequencesComputed++;

          // Ignore consequences that have a tiny probability of happening.
          var cumulativeProbability = next.cumulativeProbability;
          if (cumulativeProbability < minimumCumulativeProbability) {
            continue;
          }

          // Ignore consequences that have already been
          if (closed.contains(next.world)) {
            continue;
          }

          open.add(next);
        }
      }

      if (!hasConsequence) {
        // Add to results because this consequence is a final one (end game?).
        results.add(current);
      }

      closed.add(current.world);
    }

    return results;
  }
}
