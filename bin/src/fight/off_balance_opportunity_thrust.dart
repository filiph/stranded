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
        a.pose == Pose.standing &&
        enemy.pose == Pose.offBalance &&
        a.wields(ItemType.SWORD),
    chance: 0.6, success: (a, enemy, WorldState w, Storyline s) {
  a.report(s, "<subject> {stab<s>|run<s> <subject's> sword through} <object>",
      object: enemy, positive: true);
  enemy.report(s, "<subject> collapse<s>, dead",
      negative: true, endSentence: true);
  s.addParagraph();
  w.updateActorById(enemy.id, (b) => b.isAlive = false);
  return "${a.name} stabs ${enemy.name}";
}, failure: (Actor a, Actor enemy, WorldState w, Storyline s) {
  a.report(s, "<subject> tr<ies> to stab <object>", object: enemy);
  a.report(s, "<subject> {fail<s>|miss<es>}", but: true);
  return "${a.name} fails to stab ${enemy.name}";
});
