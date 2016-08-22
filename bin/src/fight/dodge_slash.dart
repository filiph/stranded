import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/storyline/storyline.dart';

import 'slash_situation.dart';

var dodgeSlash = new EnemyTargetActionGenerator("dodge it",
    valid: (Actor a, enemy, WorldState w) =>
        w.currentSituation.state is SlashSituation,
    chance: 0.5, success: (a, enemy, WorldState w, Storyline s) {
  a.report(s, "<subject> dodge<s> it", object: enemy, positive: true);
  return "${a.name} dodges ${enemy.name}";
}, failure: (Actor a, Actor enemy, WorldState w, Storyline s) {
  a.report(s, "<subject> tr<ies> to dodge");
  enemy.report(
      s,
      "<subject> {slash<es>|cut<s>} {across|through} <object's> "
      "{neck|abdomen|lower body}",
      object: a,
      but: true,
      positive: true);
  a.report(s, "<subject> fall<s> to the ground, dead",
      negative: true, endSentence: true);
  s.addParagraph();
  w.updateActorById(a.id, (b) => b.isAlive = false);
  return "${a.name} fails to dodge ${enemy.name}";
});
