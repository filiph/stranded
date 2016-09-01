library stranded.action;

import 'package:meta/meta.dart';

import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/plan_consequence.dart';
import 'package:stranded/action_record.dart';
import 'package:stranded/storyline/storyline.dart';

typedef String _ActorActionFunction(
    Actor actor, WorldState world, Storyline storyline);

// TODO: use this to have more than 2 outcomes
//class Consequence {
//  num weight;
//  ActorActionFunction applyFunction;
//}
//
//typedef void ActorActionFunction(Actor actor, WorldState worldCopy, Storyline story);

abstract class ActorAction {
  String get name;
  String _description;

  Iterable<PlanConsequence> apply(
      Actor actor, PlanConsequence current, WorldState world) sync* {
    var successChance = getSuccessChance(actor, current.world);
    assert(successChance != null);
    assert(successChance >= 0.0);
    assert(successChance <= 1.0);

    if (successChance > 0) {
      var worldCopy = new WorldState.duplicate(world);
      Storyline storyline =
          _applyToWorldCopy(worldCopy, actor, world, applySuccess);

      yield new PlanConsequence(
          worldCopy, current, this, storyline, successChance,
          isSuccess: true);
    }
    if (successChance < 1) {
      if (!failureModifiesWorld) {
        yield new PlanConsequence(
            world, current, this, new Storyline(), 1 - successChance,
            isFailure: true);
        return;
      }

      var worldCopy = new WorldState.duplicate(world);
      Storyline storyline =
          _applyToWorldCopy(worldCopy, actor, world, applyFailure);

      yield new PlanConsequence(
          worldCopy, current, this, storyline, 1 - successChance,
          isFailure: true);
    }
  }

  Storyline _applyToWorldCopy(
      WorldState worldCopy,
      Actor actor,
      WorldState world,
      String applyFunction(
          Actor actor, WorldState world, Storyline storyline)) {
    // Find actor by id.
    var actorInWorldCopy =
        worldCopy.actors.singleWhere((a) => a.id == actor.id);
    var builder = _prepareWorldRecord(actor, world);
    // Remember situation as it can be changed during applySuccess.
    var storyline = new Storyline();
    var situationId = worldCopy.currentSituation.id;
    int hashCode = worldCopy.hashCode;
    worldCopy.currentSituation.onBeforeAction(worldCopy, storyline);
    if (worldCopy.hashCode != hashCode) {
      throw new StateError("Please don't change the world in onBeforeAction");
    }
    _description = applyFunction(actorInWorldCopy, worldCopy, storyline);
    worldCopy.updateSituationById(
        situationId, (b) => b.state = b.state.elapseTime());
    worldCopy.elapseTime();
    worldCopy
        .getSituationById(situationId)
        ?.onAfterAction(worldCopy, storyline);

    // Remove ended situations: the ones that don't return an actor anymore,
    // and the ones that return shouldContinue(world) == true.
    while (worldCopy.currentSituation?.state?.getCurrentActor(worldCopy) ==
            null ||
        worldCopy.currentSituation?.state?.shouldContinue(worldCopy) != true) {
      if (worldCopy.currentSituation == null) break;
      worldCopy.popSituation();
    }
    _addWorldRecord(builder, worldCopy);
    return storyline;
  }

  /// Changes the [world].
  String applyFailure(Actor actor, WorldState world, Storyline storyline);
  String applySuccess(Actor actor, WorldState world, Storyline storyline);

  /// Success chance of the action given the actor and the state of the world.
  num getSuccessChance(Actor actor, WorldState world);

  bool isApplicable(Actor actor, WorldState world);

  /// This is `false` when failure to do this action just results in nothing.
  /// This means we can skip creating a new [WorldState] copy.
  bool get failureModifiesWorld => throw new UnimplementedError();

  ActionRecordBuilder _prepareWorldRecord(Actor actor, WorldState world) =>
      new ActionRecordBuilder()
        ..actionName = name
        ..protagonist = actor
        ..markBeforeAction(world);

  void _addWorldRecord(ActionRecordBuilder builder, WorldState world) {
    if (_description == null) {
      throw new StateError("No description given when executing $this. You "
          "should return it from your world-modifying function.");
    }
    builder.markAfterAction(world);
    builder.description = _description;
    builder.time = world.time;
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

  String applyFailure(Actor actor, WorldState world, Storyline storyline) =>
      _applyFailure(actor, world, storyline);

  String applySuccess(Actor actor, WorldState world, Storyline storyline) =>
      _applySuccess(actor, world, storyline);

  num getSuccessChance(Actor actor, WorldState world) => successChance;
  bool isApplicable(Actor actor, WorldState world) =>
      _isApplicable(actor, world);

  toString() => name;
}

/// Builder generates multiple [ActorAction] instances given a [world] and
/// an [actor].
///
/// For example, an action builder called `hitWithStick` can take the current
/// world and output as many actions as there are things to hit with a stick.
/// Each generated action will encapsulate the thing to hit.
abstract class ActionGenerator {
  Iterable<ActorAction> build(Actor actor, WorldState world);
}

class EnemyTargetActionGenerator extends ActionGenerator {
  final String name;
  final EnemyTargetApplicabilityFunction valid;
  final EnemyTargetActionFunction success;
  final EnemyTargetActionFunction failure;
  final EnemyTargetChanceFunction chance;

  EnemyTargetActionGenerator(this.name,
      {@required this.valid,
      this.success,
      this.failure,
      @required this.chance});

  @override
  Iterable<ActorAction> build(Actor actor, WorldState world) {
    var situationActors =
        world.currentSituation.state.getActors(world.actors, world);
    var enemies =
        situationActors.where((other) => other.team.isEnemyWith(actor.team));
    return enemies.map/*<ActorAction>*/((Actor enemy) => new EnemyTargetAction(
        (new Storyline()..add(name, object: enemy)).realize(),
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
  final EnemyTargetChanceFunction chance;
  final Actor enemy;

  EnemyTargetAction(this.name,
      {@required this.enemy,
      @required this.valid,
      this.success,
      this.failure,
      @required this.chance});

  @override
  String applyFailure(Actor actor, WorldState world, Storyline storyline) =>
      failure(actor, enemy, world, storyline);

  @override
  String applySuccess(Actor actor, WorldState world, Storyline storyline) =>
      success(actor, enemy, world, storyline);

  @override
  bool get failureModifiesWorld => failure != null;

  @override
  num getSuccessChance(Actor actor, WorldState world) =>
      chance(actor, enemy, world);

  @override
  bool isApplicable(Actor actor, WorldState world) =>
      valid(actor, enemy, world);

  String toString() => name;
}

typedef bool EnemyTargetApplicabilityFunction(
    Actor actor, Actor enemy, WorldState world);

typedef String EnemyTargetActionFunction(
    Actor actor, Actor enemy, WorldState world, Storyline storyline);

typedef num EnemyTargetChanceFunction(
    Actor actor, Actor enemy, WorldState world);
