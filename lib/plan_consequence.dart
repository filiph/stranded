library stranded.plan_consequence;

import 'package:quiver/core.dart';
import 'package:stranded/action.dart';
import 'package:stranded/world.dart';
import 'package:stranded/storyline/storyline.dart';

class PlanConsequence {
  final WorldState world;
  final ActorAction action;
  final Storyline storyline;
  final num probability;
  final num cumulativeProbability;

  final bool isInitial;
  final bool isFailure;
  final bool isSuccess;

  /// How far are we from initial world state.
  final int order;

  PlanConsequence(this.world, PlanConsequence previous, this.action,
      this.storyline, num probability,
      {this.isInitial: false, this.isFailure: false, this.isSuccess: false})
      : order = previous == null ? 0 : previous.order + 1,
        cumulativeProbability = previous == null
            ? probability
            : probability * previous.cumulativeProbability,
        probability = probability {
    storyline.time = world.time;
  }

  PlanConsequence.initial(WorldState world)
      : this(world, null, null, new Storyline(), 1.0, isInitial: true);

  @override
  int get hashCode => hashObjects([
        world,
        cumulativeProbability,
        action,
        probability,
        order,
        isInitial,
        isFailure,
        isSuccess
      ]);

  bool operator ==(o) => o is PlanConsequence && hashCode == o.hashCode;

  toString() =>
      "PlanConsequence<${world.hashCode}, $world, $action, $probability, "
      "$order, ${isSuccess ? 'isSuccess' : ''}>";
}

/// A container for statistics for a [PlanConsequence].
class ConsequenceStats {
  final num score;
  final num cumulativeProbability;
  final int order;
  const ConsequenceStats(this.score, this.cumulativeProbability, this.order);
}
