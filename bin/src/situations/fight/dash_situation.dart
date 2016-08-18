import 'package:stranded/situation.dart';
import 'package:stranded/actor.dart';
import 'package:quiver/core.dart';
import 'package:stranded/action.dart';
import 'dodge_dash.dart';

class DashSituation extends Situation {
  final Actor attacker;
  final Actor target;

  DashSituation(this.attacker, this.target, {int time: 0}) : super(time);

  List<ActionBuilder> actionBuilderWhitelist = <ActionBuilder>[dodgeDash];

  @override
  Situation clone() => new DashSituation(
      new Actor.duplicate(attacker), new Actor.duplicate(target),
      time: time);

  @override
  int get hashCode => hash2(attacker, target);

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
