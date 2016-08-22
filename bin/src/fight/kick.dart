import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/situation.dart';
import 'package:stranded/storyline/storyline.dart';

import 'off_balance_opportunity_situation.dart';

var kickOffBalance = new EnemyTargetActionGenerator("kick <object>",
    valid: (Actor a, enemy, w) =>
        a.pose == Pose.standing &&
        enemy.pose == Pose.standing,
    chance: 1.0, success: (a, enemy, WorldState w, Storyline s) {
  a.report(s, "<subject> kick<s> <object>", object: enemy);
  w.updateActorById(enemy.id, (b) => b..pose = Pose.offBalance);
  var situation =
      new Situation.withState(new OffBalanceOpportunitySituation((b) => b
        ..actorId = enemy.id
        ..culpritId = a.id));
  w.pushSituation(situation);
  return "${a.name} kicks ${enemy.name}";
});
