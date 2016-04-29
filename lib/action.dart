library stranded.action;

import 'package:stranded/actor.dart';
import 'package:stranded/planner.dart';
import 'package:stranded/world.dart';

//  XXX ACTION GENERATORS THAT YIELD DIFFERENT ACTIONS (different targets, mostly) - EAT action generates Eat<Fish>, Eat<Grass> etc.
// Maybe: Actions types - withOthers ("when the evening's at end"), without ("meanwhile"), elsewhere ("")

typedef void _ActorActionFunction(Actor actor, WorldState world);

abstract class ActorAction {
  Iterable<PlanConsequence> apply(
      Actor actor, PlanConsequence current, WorldState worldCopy) sync* {
    var successChance = getSuccessChance(actor, current.world);
    assert(successChance != null);
    if (successChance > 0) {
      applySuccess(actor, worldCopy);
      yield new PlanConsequence(worldCopy, current, this, successChance,
          isSuccess: true);
    }
    if (successChance < 1) {
      applyFailure(actor, worldCopy);
      yield new PlanConsequence(worldCopy, current, this, 1 - successChance,
          isFailure: true);
    }
  }


  /// Changes the [world].
  void applyFailure(Actor actor, WorldState world);
  void applySuccess(Actor actor, WorldState world);

  /// Success chance of the action given the actor and the state of the world.
  num getSuccessChance(Actor actor, WorldState world);

  bool isApplicable(Actor actor, WorldState world);
}

class DebugActorAction extends ActorAction {
  final String name;
  final Function _isApplicable;
  final _ActorActionFunction _applySuccess;
  final _ActorActionFunction _applyFailure;
  final num successChance;

  DebugActorAction(this.name, this._isApplicable, this._applySuccess,
      this._applyFailure, this.successChance);

  void applyFailure(Actor actor, WorldState world) {
    _applyFailure(actor, world);
  }

  void applySuccess(Actor actor, WorldState world) {
    _applySuccess(actor, world);
  }

  num getSuccessChance(Actor actor, WorldState world) => successChance;
  bool isApplicable(Actor actor, WorldState world) =>
      _isApplicable(actor, world);

  toString() => "DebugActorAction<$name>";
}
