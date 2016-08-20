import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/item.dart';
import 'package:stranded/world.dart';
import 'package:stranded/situation.dart';
import 'package:stranded/storyline/storyline.dart';

import 'dash_situation.dart';

var dashWithSword = new EnemyTargetActionGenerator("dash at <subject>",
    valid: (Actor a, enemy, w) => a.wields(ItemType.SWORD),
    chance: 1.0, success: (a, enemy, WorldState w, Storyline s) {
  a.report(s, "<subject> dash<es> at <object>", object: enemy, positive: true);
  var situation = new Situation.withState(new DashSituation((b) => b
    ..attacker = a
    ..target = enemy));
  w.pushSituation(situation);
  return "$a dashes at $enemy";
});
