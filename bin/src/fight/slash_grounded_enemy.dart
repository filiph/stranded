import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/item.dart';
import 'package:stranded/situation.dart';
import 'package:stranded/storyline/storyline.dart';
import 'package:stranded/world.dart';

import 'fight_situation.dart';
import 'slash_situation.dart';

var slashGroundedEnemy = new EnemyTargetActionGenerator("swing at <object>",
    valid: (Actor a, enemy, w) =>
        w.currentSituation.state is FightSituation && a.wields(ItemType.SWORD),
    chance: 1.0, success: (a, enemy, WorldState w, Storyline s) {
//      XXX START HERE
  a.report(s, "<subject> swing<s> {<subject's> sword |}at <object>",
      object: enemy);
  var situation = new Situation.withState(new SlashSituation((b) => b
    ..attacker = a
    ..target = enemy));
  w.pushSituation(situation);
  return "${a.name} slashes at ${enemy.name}";
});
