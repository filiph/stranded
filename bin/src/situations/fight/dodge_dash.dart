import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/item.dart';
import 'dash_situation.dart';
import 'package:stranded/world.dart';

var dodgeDash = new EnemyTargetActionGenerator("dodge dash",
    valid: (Actor a, enemy, WorldState w) =>
        w.currentSituation.state is DashSituation && a.wields(ItemType.SWORD),
    chance: 0.5, success: (a, enemy, WorldState w) {
  //print("$a successfully dodges $enemy's dash");
  w.popSituation();
  return "$a dodges $enemy";
}, failure: (Actor a, enemy, WorldState w) {
  //print("$a tr<ies> to dodge but $enemy slashes him");
  w.updateActorById(a.id, (b) => b.health = 0);
  w.popSituation();
  return "$a fails to dodge $enemy";
});
