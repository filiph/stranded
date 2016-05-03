
import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/planner.dart';
import '../test/planner_test.dart';

main() {
  var filip = new Actor(1, "Filip");
  var ted = new Actor(100, "Ted");
  var helen = new Actor(500, "Helen");
  filip.safetyFear[ted] = new Scale(-0.1);
  filip.safetyFear[helen] = new Scale(0.5);
  ted.safetyFear[filip] = new Scale(-0.5);
  ted.safetyFear[helen] = new Scale(0.0);
  helen.safetyFear[filip] = new Scale(0.2);
  helen.safetyFear[ted] = new Scale(-0.5);

  var world = new WorldState(new Set.from([filip, ted, helen]));

  var actions = defineActions();

  world.validate();

  var planner = new ActorPlanner(filip, world, new Set.from(actions));

  planner.plan();
  print("> ${planner.getBest()}");
  print("planConsequencesComputed > ${planner.planConsequencesComputed}");
}