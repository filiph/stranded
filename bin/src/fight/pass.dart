import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/storyline/storyline.dart';
import 'off_balance_opportunity_situation.dart';

var passOpportunity = new EnemyTargetActionGenerator("pass",
    valid: (Actor a, enemy, w) =>
        w.currentSituation.state is OffBalanceOpportunitySituation,
    chance: 1.0, success: (a, enemy, WorldState w, Storyline s) {
  return "$a passes the opportunity";
});
