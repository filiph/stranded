library stranded.fight.off_balance_situation;

import 'package:built_value/built_value.dart';

import 'package:stranded/situation.dart';
import 'package:stranded/actor.dart';
import 'package:quiver/core.dart';
import 'package:stranded/action.dart';
import 'dodge_slash.dart';
import 'parry_slash.dart';
import 'package:stranded/world.dart';
import 'package:stranded/storyline/randomly.dart';
import 'pass.dart';

part 'off_balance_situation.g.dart';

abstract class OffBalanceSituation extends SituationState
    with ElapsingTime<OffBalanceSituation, OffBalanceSituationBuilder>
    implements Built<OffBalanceSituation, OffBalanceSituationBuilder> {
  int get time;
  int get actorId;

  OffBalanceSituation._();
  factory OffBalanceSituation([updates(OffBalanceSituationBuilder b)]) =
      _$OffBalanceSituation;
  factory OffBalanceSituation.withValues(Actor actor, {int time: 0}) =>
      new OffBalanceSituation((b) => b
        ..actorId = actor.id
        ..time = time);

  @override
  List<ActionGenerator> get actionBuilderWhitelist =>
      <ActionGenerator>[passOpportunity, slash];

  @override
  Actor getActorAtTime(int time, WorldState world) {
    var actor = world.getActorById(actorId);
    List<Actor> enemies =
        world.actors.where((a) => a.isEnemyOf(actor)).toList();
    if (enemies.isNotEmpty) {
      if (time == 0) return Randomly.choose(enemies);
      if (time == 1) return actor;
      throw new StateError("$this should have ended with actor's move");
    }
    if (time == 0) return actor;
    throw new StateError("$this should have ended with actor's move");
  }

  @override
  Iterable<Actor> getActors(Iterable<Actor> actors, WorldState world) {
    var actor = world.getActorById(actorId);
    return actors.where((a) => a == actor || a.isEnemyOf(actor));
  }
}

abstract class OffBalanceSituationBuilder
    implements
        Builder<OffBalanceSituation, OffBalanceSituationBuilder>,
        SituationStateBuilderBase {
  int time = 0;
  int actorId;

  OffBalanceSituationBuilder._();
  factory OffBalanceSituationBuilder() = _$OffBalanceSituationBuilder;
}
