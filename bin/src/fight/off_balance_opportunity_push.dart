import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/storyline/storyline.dart';

import 'off_balance_opportunity_situation.dart';

var offBalanceOpportunityPush = new EnemyTargetActionGenerator("push <object>",
    valid: (Actor a, enemy, WorldState w) =>
        w.currentSituation.state is OffBalanceOpportunitySituation &&
        a.pose == Pose.standing &&
        enemy.pose == Pose.offBalance,
    chance: 0.7, success: (a, enemy, WorldState w, Storyline s) {
  a.report(s, "<subject> push<es> <object>", object: enemy);
  enemy.report(s, "<subject> fall<s> to the ground", negative: true);
  w.updateActorById(enemy.id, (b) => b.pose = Pose.onGround);
  return "${a.name} pushes ${enemy.name}";
}, failure: (Actor a, Actor enemy, WorldState w, Storyline s) {
  if (a.isPlayer) {
    a.report(s, "<subject> tr<ies> to push <object>", object: enemy);
    enemy.report(s, "<subject> stand<s> firm", but: true);
  }
  return "${a.name} fails to push ${enemy.name}";
});
