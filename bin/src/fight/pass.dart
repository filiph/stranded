import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/storyline/storyline.dart';
import 'off_balance_opportunity_situation.dart';

var passOpportunity = new EnemyTargetActionGenerator("pass",
    valid: (Actor a, enemy, w) => true,
    chance: 1.0, success: (a, enemy, WorldState w, Storyline s) {
  return "${a.name} passes the opportunity";
});
