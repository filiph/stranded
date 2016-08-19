library stranded.fight.dash_situation;

import 'package:built_value/built_value.dart';

import 'package:stranded/situation.dart';
import 'package:stranded/actor.dart';
import 'package:quiver/core.dart';
import 'package:stranded/action.dart';
import 'dodge_dash.dart';

part 'dash_situation.g.dart';

abstract class DashSituation extends SituationState
    with ElapsingTime<DashSituation, DashSituationBuilder>
    implements Built<DashSituation, DashSituationBuilder> {
  int get time;
  Actor get attacker;
  Actor get target;

  DashSituation._();
  factory DashSituation([updates(DashSituationBuilder b)]) = _$DashSituation;
  factory DashSituation.withValues(Actor attacker, Actor target,
          {int time: 0}) =>
      new DashSituation((b) => b
        ..attacker = attacker
        ..target = target
        ..time = time);

  @override
  List<ActionGenerator> get actionBuilderWhitelist =>
      <ActionGenerator>[dodgeDash];

  @override
  Actor getActorAtTime(int i) {
    if (i == 0) return target;
    throw new RangeError.range(
        i, 0, 0, "Only the target has a turn during a dash");
  }

  @override
  Iterable<Actor> getActors(Iterable<Actor> actors) =>
      actors.where((actor) => actor == attacker || actor == target);
}

abstract class DashSituationBuilder
    implements
        Builder<DashSituation, DashSituationBuilder>,
        SituationStateBuilderBase {
  int time = 0;
  Actor attacker;
  Actor target;

  DashSituationBuilder._();
  factory DashSituationBuilder() = _$DashSituationBuilder;
}
