library stranded.planner;

import 'dart:collection';

import 'package:quiver/core.dart';
import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';

class ActorPlanner {
  /// We will stop processing a plan path once its leaf node has lower
  /// probability than this.
  static const minimumCumulativeProbability = 0.01;
  final int actorId;
  final WorldState initialWorld;
  final PlanConsequence _initial;

  final Set<ActorAction> actions;
  int planConsequencesComputed = 0;
  bool _resultsReady = false;

  PlanConsequence _best;

  ActorPlanner(Actor actor, WorldState initialWorld, this.actions)
      : actorId = actor.id,
        initialWorld = initialWorld,
        _initial = new PlanConsequence.initial(initialWorld);

//  XXX START HERE get score distribution of order 0 actions (instead of walking backwards from "best", try to find out which actions give best results on average)

  ActorAction getBest() {
    assert(_resultsReady);
    assert(_best != null);

    PlanConsequence current = _best;
    // Walk backwards
    while (current.previous != _initial) {
      current = current.previous;
    }

    return current.action;
  }

  /// Searches the state space via breadth first search.
  ///
  /// The search stops when paths of [maxOrder] are reached (e.g., 3 actions
  /// ahead for `maxOrder: 3`). Paths are pruned when the cumulative probability
  /// of a particular consequence is below [minimumCumulativeProbability].
  void plan({int maxOrder: 3}) {
    num bestScore;

    final open = new Queue<PlanConsequence>();
    final closed = new Set<WorldState>();
    open.add(_initial);

    var currentActor =
        _initial.world.actors.singleWhere((a) => a.id == actorId);
    var initialScore = currentActor.scoreWorld(_initial.world);

    while (open.isNotEmpty) {
      var current = open.removeFirst();
      if (current.order >= maxOrder) break;

      // Actor object changes during planning, so we need to look up via id.
      currentActor = current.world.actors.singleWhere((a) => a.id == actorId);

      for (ActorAction action in actions) {
        if (!action.isApplicable(currentActor, current.world)) continue;
        var worldCopy = new WorldState.from(current.world);
        var consequences = action.apply(currentActor, current, worldCopy);
        for (PlanConsequence next in consequences) {
          planConsequencesComputed++;
          var cumulativeProbability = next.cumulativeProbability;
          if (cumulativeProbability < minimumCumulativeProbability) {
            continue;
          }
          // print(next);
          if (closed.contains(next.world)) {
            continue;
          }
          open.add(next);
          // TODO: actors have 'reasoningStyle' that affects how they score
          //       enum { OPTIMISTIC, ANALYTICAL, HOLISTIC_AVERAGE }
          var uplift = currentActor.scoreWorld(next.world) - initialScore;
          var score = initialScore + uplift * cumulativeProbability;
          if (bestScore == null || score > bestScore) {
            _best = next;
            bestScore = score;
          }
        }
      }

      closed.add(current.world);
    }

    _resultsReady = true;
  }
}

class PlanConsequence {
  final WorldState world;
  final PlanConsequence previous;
  final ActorAction action;
  final probability;

  final bool isInitial;
  final bool isFailure;
  final bool isSuccess;

  /// How far are we from initial world state.
  final int order;

  PlanConsequence(
      this.world, PlanConsequence previous, this.action, this.probability,
      {this.isInitial: false, this.isFailure: false, this.isSuccess: false})
      : order = previous == null ? 0 : previous.order + 1,
        previous = previous;

  PlanConsequence.initial(WorldState world)
      : this(world, null, null, 1.0, isInitial: true);

  num get cumulativeProbability => probabilities.fold(1, (a, b) => a * b);

  @override
  int get hashCode => hashObjects([
        world,
        previous,
        action,
        probability,
        order,
        isInitial,
        isFailure,
        isSuccess
      ]);

  Iterable<num> get probabilities sync* {
    yield probability;
    PlanConsequence current = this;
    while (current.previous != null) {
      yield current.probability;
      current = current.previous;
    }
  }

  bool operator ==(o) => o is PlanConsequence && hashCode == o.hashCode;

  toString() =>
      "PlanConsequence<${world.hashCode}, $world, $action, $probability, ${previous?.world?.hashCode}, $order, ${isSuccess ? 'isSuccess' : ''}>";
}
