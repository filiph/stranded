import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/item.dart';
import 'package:stranded/world.dart';
import 'package:stranded/storyline/storyline.dart';

import 'slash_situation.dart';

var parrySlash = new EnemyTargetActionGenerator("parry it",
    valid: (Actor a, enemy, WorldState w) =>
        w.currentSituation.state is SlashSituation && a.wields(ItemType.SWORD),
    chance: 0.6, success: (a, enemy, WorldState w, Storyline s) {
  a.report(s, "<subject> {parr<ies> it|meet<s> it with <subject's> sword}",
      object: enemy, positive: true);
  return "${a.name} parries ${enemy.name}";
}, failure: (Actor a, Actor enemy, WorldState w, Storyline s) {
  a.report(s, "<subject> tr<ies> to {parry|meet it with <subject's> sword}");
  enemy.report(s, "<subject> slash<es> <object>",
      object: a, but: true, positive: true);
  a.report(s, "<subject> fall<s> to the ground", negative: true);
  a.report(s, "<subject> die<s>", negative: true);
  s.addParagraph();
  w.updateActorById(a.id, (b) => b.isAlive = false);
  return "${a.name} fails to dodge ${enemy.name}";
});
