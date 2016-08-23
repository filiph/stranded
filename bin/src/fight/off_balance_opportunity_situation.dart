library stranded.fight.off_balance_situation;

import 'package:built_value/built_value.dart';

import 'package:stranded/situation.dart';
import 'package:stranded/actor.dart';
import 'package:quiver/core.dart';
import 'package:stranded/world.dart';
import 'off_balance_opportunity_thrust.dart';
import 'pass.dart';

part 'off_balance_opportunity_situation.g.dart';

abstract class OffBalanceOpportunitySituation extends SituationState
    with
        ElapsingTime<OffBalanceOpportunitySituation,
            OffBalanceOpportunitySituationBuilder>
    implements
        Built<OffBalanceOpportunitySituation,
            OffBalanceOpportunitySituationBuilder> {
  int get time;

  /// The actor who is off balance.
  int get actorId;

  /// The actor who caused [actorId] to be off balance.
  @nullable
  int get culpritId;

  OffBalanceOpportunitySituation._();
  factory OffBalanceOpportunitySituation(
          [updates(OffBalanceOpportunitySituationBuilder b)]) =
      _$OffBalanceOpportunitySituation;
  factory OffBalanceOpportunitySituation.withValues(Actor actor,
          {int time: 0}) =>
      new OffBalanceOpportunitySituation((b) => b
        ..actorId = actor.id
        ..time = time);

  get actions => [pass];
  get actionGenerators => [offBalanceOpportunityThrust];

  @override
  Actor getActorAtTime(int time, WorldState world) {
    if (time > 0) return null;
    var actor = world.getActorById(actorId);
    List<Actor> enemies = world.actors
        .where((a) =>
            a.isAliveAndActive && a.isEnemyOf(actor) && a.id != culpritId)
        .toList();
    // TODO: sort by distance, cut off if too far

    if (enemies.isNotEmpty) {
      var candidate = enemies.first;
      // Only change the situation when the candidate can actually pull it off.
      if (offBalanceOpportunityThrust.valid(candidate, actor, world)) {
        return candidate;
      }
    }
    return null;
  }

  @override
  Iterable<Actor> getActors(Iterable<Actor> actors, WorldState world) {
    var actor = world.getActorById(actorId);
    return actors.where((a) => a == actor || a.isEnemyOf(actor));
  }
}

abstract class OffBalanceOpportunitySituationBuilder
    implements
        Builder<OffBalanceOpportunitySituation,
            OffBalanceOpportunitySituationBuilder>,
        SituationStateBuilderBase {
  int time = 0;
  int actorId;
  @nullable
  int culpritId;

  OffBalanceOpportunitySituationBuilder._();
  factory OffBalanceOpportunitySituationBuilder() =
      _$OffBalanceOpportunitySituationBuilder;
}
