import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/item.dart';
import 'package:stranded/world.dart';
import 'package:stranded/storyline/storyline.dart';

import 'dash_situation.dart';

var dodgeDash = new EnemyTargetActionGenerator("dodge dash",
    valid: (Actor a, enemy, WorldState w) =>
        w.currentSituation.state is DashSituation && a.wields(ItemType.SWORD),
    chance: 0.5, success: (a, enemy, WorldState w, Storyline s) {
  //print("$a successfully dodges $enemy's dash");
  a.report(s, "<subject> dodge<s> <object's> dash", object: enemy);
  w.popSituation();
  return "$a dodges $enemy";
}, failure: (Actor a, Actor enemy, WorldState w, Storyline s) {
  //print("$a tr<ies> to dodge but $enemy slashes him");
  enemy.report(s, "despite the dodge attempt, <subject> slash<es> <object>",
      object: a);
  w.updateActorById(a.id, (b) => b.health = 0);
  w.popSituation();
  return "$a fails to dodge $enemy";
});
