library stranded.fight.dash_situation;

import 'package:built_value/built_value.dart';

import 'package:stranded/situation.dart';
import 'package:stranded/actor.dart';
import 'package:quiver/core.dart';

part 'slash_situation.g.dart';

abstract class SlashSituation extends SituationState
    with ElapsingTime<SlashSituation, SlashSituationBuilder>
    implements Built<SlashSituation, SlashSituationBuilder> {
  int get time;
  Actor get attacker; // TODO: use id instead
  Actor get target;

  SlashSituation._();
  factory SlashSituation([updates(SlashSituationBuilder b)]) = _$SlashSituation;
  factory SlashSituation.withValues(Actor attacker, Actor target,
          {int time: 0}) =>
      new SlashSituation((b) => b
        ..attacker = attacker
        ..target = target
        ..time = time);

  @override
  Actor getActorAtTime(int time, _) {
    if (time == 0) return target;
    return null;
  }

  @override
  Iterable<Actor> getActors(Iterable<Actor> actors, _) =>
      actors.where((actor) => actor == attacker || actor == target);
}

abstract class SlashSituationBuilder
    implements
        Builder<SlashSituation, SlashSituationBuilder>,
        SituationStateBuilderBase {
  int time = 0;
  Actor attacker;
  Actor target;

  SlashSituationBuilder._();
  factory SlashSituationBuilder() = _$SlashSituationBuilder;
}
