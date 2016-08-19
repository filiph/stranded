library stranded.fight.fight_situation;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:quiver/core.dart';

import 'package:stranded/actor.dart';
import 'package:stranded/situation.dart';
import 'package:stranded/util/alternate_iterables.dart';

part 'fight_situation.g.dart';

abstract class FightSituation extends SituationState
    with ElapsingTime<FightSituation, FightSituationBuilder>
    implements Built<FightSituation, FightSituationBuilder> {
  int get time;
  BuiltList<Actor> get playerTeam;
  BuiltList<Actor> get enemyTeam;

  FightSituation._();
  factory FightSituation([updates(FightSituationBuilder b)]) = _$FightSituation;

  @override
  Actor getActorAtTime(int i) {
    // TODO: add _lastActor and use that to offset [i] if needed (when one of
    //       the actors is removed during the fight.
    var allActors =
        alternate/*<Actor>*/(playerTeam, enemyTeam).toList(growable: false);
    i = i % allActors.length;
    return allActors[i];
  }

  @override
  Iterable<Actor> getActors(Iterable<Actor> actors) => actors.where(
      (actor) => playerTeam.contains(actor) || enemyTeam.contains(actor));
}

abstract class FightSituationBuilder
    implements
        Builder<FightSituation, FightSituationBuilder>,
        SituationStateBuilderBase {
  int time = 0;
  BuiltList<Actor> playerTeam;
  BuiltList<Actor> enemyTeam;

  FightSituationBuilder._();
  factory FightSituationBuilder() = _$FightSituationBuilder;
}
