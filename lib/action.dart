library stranded.action;

import 'package:meta/meta.dart';

import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/plan_consequence.dart';
import 'package:stranded/action_record.dart';

// XXX ACTION GENERATORS THAT YIELD DIFFERENT ACTIONS (different targets, mostly) - EAT action generates Eat<Fish>, Eat<Grass> etc.
// Maybe: Actions types - withOthers ("when the evening's at end"), without ("meanwhile"), elsewhere ("")

typedef String _ActorActionFunction(Actor actor, WorldState world);

abstract class ActorAction {
  String _description;

  Iterable<PlanConsequence> apply(
      Actor actor, PlanConsequence current, WorldState world) sync* {
    var successChance = getSuccessChance(actor, current.world);
    assert(successChance != null);

    if (successChance > 0) {
      var worldCopy = new WorldState.duplicate(world);
      var actorInWorldCopy =
          worldCopy.actors.singleWhere((a) => a.id == actor.id);
      var builder = _prepareWorldRecord(actor, world);
      // Remember situation as it can be changed during applySuccess.
      var situation = worldCopy.currentSituation;
      _description = applySuccess(actorInWorldCopy, worldCopy);
      situation.elapseTime();
      worldCopy.elapseTime();
      _addWorldRecord(builder, worldCopy);

      yield new PlanConsequence(worldCopy, current, this, successChance,
          isSuccess: true);
    }
    if (successChance < 1) {
      if (!failureModifiesWorld) {
        yield new PlanConsequence(world, current, this, 1 - successChance,
            isFailure: true);
        return;
      }

      var worldCopy = new WorldState.duplicate(world);
      var actorInWorldCopy =
          worldCopy.actors.singleWhere((a) => a.id == actor.id);
      var builder = _prepareWorldRecord(actor, world);
      // Remember situation as it can be changed during applyFailure.
      var situation = worldCopy.currentSituation;
      _description = applyFailure(actorInWorldCopy, worldCopy);
      situation.elapseTime();
      worldCopy.elapseTime();
      _addWorldRecord(builder, worldCopy);

      yield new PlanConsequence(worldCopy, current, this, 1 - successChance,
          isFailure: true);
    }
  }

  /// Changes the [world].
  String applyFailure(Actor actor, WorldState world);
  String applySuccess(Actor actor, WorldState world);

  /// Success chance of the action given the actor and the state of the world.
  num getSuccessChance(Actor actor, WorldState world);

  bool isApplicable(Actor actor, WorldState world);

  /// This is `false` when failure to do this action just results in nothing.
  /// This means we can skip creating a new [WorldState] copy.
  bool get failureModifiesWorld => throw new UnimplementedError();

  ActionRecordBuilder _prepareWorldRecord(Actor actor, WorldState world) =>
      new ActionRecordBuilder()
        ..protagonist = actor
        ..markBeforeAction(world);

  void _addWorldRecord(ActionRecordBuilder builder, WorldState world) {
    if (_description == null) {
      throw new StateError("No description given when executing $this. You "
          "should return it from your world-modifying function.");
    }
    builder.markAfterAction(world);
    world.actionRecords.add(builder.build());
  }
}

class ClosureActorAction extends ActorAction {
  final String name;
  final Function _isApplicable;
  final _ActorActionFunction _applySuccess;
  final _ActorActionFunction _applyFailure;
  final num successChance;
  final bool failureModifiesWorld;

  ClosureActorAction(this.name, this._isApplicable, this._applySuccess,
      _ActorActionFunction applyFailure, this.successChance)
      : _applyFailure = applyFailure,
        failureModifiesWorld = applyFailure != null;

  String applyFailure(Actor actor, WorldState world) =>
      _applyFailure(actor, world);

  String applySuccess(Actor actor, WorldState world) =>
      _applySuccess(actor, world);

  num getSuccessChance(Actor actor, WorldState world) => successChance;
  bool isApplicable(Actor actor, WorldState world) =>
      _isApplicable(actor, world);

  toString() => "ClosureActorAction<$name>";
}

/// Builder generates multiple [ActorAction] instances given a [world] and
/// an [actor].
///
/// For example, an action builder called `hitWithStick` can take the current
/// world and output as many actions as there are things to hit with a stick.
/// Each generated action will encapsulate the thing to hit.
abstract class ActionBuilder {
  Iterable<ActorAction> build(Actor actor, WorldState world);
}

class EnemyTargetActionBuilder extends ActionBuilder {
  final String name;
  final EnemyTargetApplicabilityFunction valid;
  final EnemyTargetActionFunction success;
  final EnemyTargetActionFunction failure;
  final num chance;

  EnemyTargetActionBuilder(this.name,
      {@required this.valid,
      this.success,
      this.failure,
      @required this.chance});

  @override
  Iterable<ActorAction> build(Actor actor, WorldState world) {
    var enemies = world.currentSituation
        .getActors(world.actors)
        .where((other) => other.team.isEnemyWith(actor.team));
    return enemies.map/*<ActorAction>*/((Actor enemy) => new EnemyTargetAction(
        name,
        enemy: enemy,
        valid: valid,
        success: success,
        failure: failure,
        chance: chance));
  }

  String toString() => "EnemyTargetActionBuilder<$name>";
}

class EnemyTargetAction extends ActorAction {
  final String name;
  final EnemyTargetApplicabilityFunction valid;
  final EnemyTargetActionFunction success;
  final EnemyTargetActionFunction failure;
  final num chance;
  final Actor enemy;

  EnemyTargetAction(this.name,
      {@required this.enemy,
      @required this.valid,
      this.success,
      this.failure,
      @required this.chance});

  @override
  String applyFailure(Actor actor, WorldState world) =>
      failure(actor, enemy, world);

  @override
  String applySuccess(Actor actor, WorldState world) =>
      success(actor, enemy, world);

  @override
  bool get failureModifiesWorld => failure != null;

  // TODO: make this into a callback instead of final variable
  @override
  num getSuccessChance(Actor actor, WorldState world) => chance;

  @override
  bool isApplicable(Actor actor, WorldState world) =>
      valid(actor, enemy, world);

  String toString() => "EnemyTargetAction<$name>";
}

typedef bool EnemyTargetApplicabilityFunction(
    Actor actor, Actor enemy, WorldState world);

typedef String EnemyTargetActionFunction(
    Actor actor, Actor enemy, WorldState world);
