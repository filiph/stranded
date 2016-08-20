library stranded.fight.fight_situation;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:quiver/core.dart';

import 'package:stranded/actor.dart';
import 'package:stranded/situation.dart';
import 'package:stranded/util/alternate_iterables.dart';
import 'package:stranded/world.dart';

part 'fight_situation.g.dart';

abstract class FightSituation extends SituationState
    with ElapsingTime<FightSituation, FightSituationBuilder>
    implements Built<FightSituation, FightSituationBuilder> {
  int get time;
  BuiltList<int> get playerTeamIds;
  BuiltList<int> get enemyTeamIds;

  FightSituation._();
  factory FightSituation([updates(FightSituationBuilder b)]) = _$FightSituation;

  @override
  void update(WorldState world) {
    bool canFight(Iterable<int> teamIds) =>
        teamIds.any((id) => world.getActorById(id).isAliveAndActive);
    if (!canFight(playerTeamIds) || !canFight(enemyTeamIds)) {
      world.popSituation();
    }
  }

  @override
  Actor getActorAtTime(int i, WorldState world) {
    // TODO: add _lastActor and use that to offset [i] if needed (when one of
    //       the actors is removed during the fight.
    var allActorIds =
        alternate/*<int>*/(playerTeamIds, enemyTeamIds).toList(growable: false);
    i = i % allActorIds.length;
    return world.getActorById(allActorIds[i]);
  }

  @override
  Iterable<Actor> getActors(Iterable<Actor> actors) => actors.where(
      (Actor actor) =>
          actor.isAliveAndActive &&
          (playerTeamIds.contains(actor.id) ||
              enemyTeamIds.contains(actor.id)));
}

abstract class FightSituationBuilder
    implements
        Builder<FightSituation, FightSituationBuilder>,
        SituationStateBuilderBase {
  int time = 0;
  BuiltList<int> playerTeamIds;
  BuiltList<int> enemyTeamIds;

  FightSituationBuilder._();
  factory FightSituationBuilder() = _$FightSituationBuilder;
}
