import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/planner.dart';
import '../test/planner_test.dart';
import 'package:stranded/action.dart';
import 'package:stranded/action_record.dart';
import 'package:stranded/item.dart';

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

  var actions = defineActions().toList();

  void gatherBranchesSuccess(Actor actor, WorldState world) {
    var recBuilder = new ActionRecordBuilder()
      ..description = "$actor gathered some strong, straight branches"
      ..protagonist = actor
      ..markBeforeAction(world);

    var branches = new Branch() * 10;
    actor.items.addAll(branches);

    recBuilder.markAfterAction(world);
    world.actionRecords.add(recBuilder.build());
  }

  var gatherBranches = new DebugActorAction("gather straight branches",
      (actor, WorldState world) => true, gatherBranchesSuccess, null, 1.0);

  actions.add(gatherBranches);

  void buildBranchTentSuccess(Actor actor, WorldState world) {
    var recBuilder = new ActionRecordBuilder()
      ..description = "$actor built a tent"
      ..protagonist = actor
      ..markBeforeAction(world);

    actor.removeItems(Branch, 8);
    actor.items.add(new Tent());

    recBuilder.markAfterAction(world);
    world.actionRecords.add(recBuilder.build());
  }

  var buildBranchTent = new DebugActorAction(
      "build a tent",
      (Actor actor, WorldState world) => actor.hasItem(Branch, count: 8),
      buildBranchTentSuccess,
      null,
      1.0);

  actions.add(buildBranchTent);

  void giveBranchTentSuccess(Actor actor, WorldState world) {
    var target = world.actors.where((a) => a != actor).last;

    var recBuilder = new ActionRecordBuilder()
      ..description = "$actor gave a tent to $target"
      ..protagonist = actor
      ..markBeforeAction(world);

    var tent = actor.removeItem(Tent);
    target.items.add(tent);

    recBuilder.markAfterAction(world);
    world.actionRecords.add(recBuilder.build());
  }

  var giveBranchTent = new DebugActorAction(
      "give a tent",
      (Actor actor, WorldState world) => actor.hasItem(Tent),
      giveBranchTentSuccess,
      null,
      1.0);

  actions.add(giveBranchTent);

  world.validate();

  var planner = new ActorPlanner(filip, world, new Set.from(actions));

  planner.plan();
  print("> ${planner.getBest()}");
  print("planConsequencesComputed > ${planner.planConsequencesComputed}");
}
