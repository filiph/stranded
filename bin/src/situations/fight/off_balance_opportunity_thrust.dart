import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/item.dart';
import 'package:stranded/world.dart';
import 'package:stranded/storyline/storyline.dart';

import 'off_balance_opportunity_situation.dart';

var offBalanceOpportunityThrust = new EnemyTargetActionGenerator(
    "stab <object>",
    valid: (Actor a, enemy, WorldState w) =>
        w.currentSituation.state is OffBalanceOpportunitySituation &&
        a.wields(ItemType.SWORD),
    chance: 0.7, success: (a, enemy, WorldState w, Storyline s) {
  a.report(s, "<subject> stab<s> <object>", object: enemy, positive: true);
  enemy.report(s, "<subject> collapse<s>", negative: true);
  w.updateActorById(enemy.id, (b) => b.isAlive = false);
  return "$a stabs $enemy";
}, failure: (Actor a, Actor enemy, WorldState w, Storyline s) {
  a.report(s, "<subject> tr<ies> to stab <object>", object: enemy);
  a.report(s, "<subject> {fail<s>|miss<es>}", but: true);
  return "$a fails to stab $enemy";
});
