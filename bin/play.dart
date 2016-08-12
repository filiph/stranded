import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/planner.dart';
import '../test/planner_test.dart';
import 'package:stranded/action.dart';
import 'package:stranded/item.dart';
import 'dart:io';
import 'package:stranded/plan_consequence.dart';

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

  List<Actor> actors = <Actor>[filip, ted, helen];

  var world = new WorldState(new Set.from([filip, ted, helen]));

  Set<ActorAction> actions = defineActions().toSet();

  String gatherBranchesSuccess(Actor actor, WorldState world) {
    List<Branch> branches = new Branch() * 10 as List<Branch>;
    actor.items.addAll(branches);
    return "$actor gathered some strong, straight branches";
  }

  var gatherBranches = new DebugActorAction("gather straight branches",
      (actor, WorldState world) => true, gatherBranchesSuccess, null, 1.0);

  actions.add(gatherBranches);

  String buildBranchTentSuccess(Actor actor, WorldState world) {
    actor.removeItems(Branch, 8);
    actor.items.add(new Tent());
    return "$actor built a tent";
  }

  var buildBranchTent = new DebugActorAction(
      "build a tent",
      (Actor actor, WorldState world) => actor.hasItem(Branch, count: 8),
      buildBranchTentSuccess,
      null,
      1.0);

  actions.add(buildBranchTent);

  String giveBranchTentSuccess(Actor actor, WorldState world) {
    var target = world.actors.where((a) => a != actor).last;

    var tent = actor.removeItem(Tent);
    target.items.add(tent);

    return "$actor gave a tent to $target";
  }

  var giveBranchTent = new DebugActorAction(
      "give a tent",
      (Actor actor, WorldState world) =>
          actor.hasItem(Tent) && world.actors.length > 1,
      giveBranchTentSuccess,
      null,
      1.0);

  actions.add(giveBranchTent);

  world.validate();

  while (true) {
    for (var actor in actors) {
      actor = world.actors.singleWhere((candidate) => actor == candidate);
      var planner = new ActorPlanner(actor, world, actions);
      print("Planning for $actor");
      planner.plan();

      ActorAction selected;
      if (actor == filip) {
        // Player
        planner.generateTable().forEach(print);
        int option = int.parse(stdin.readLineSync());
        selected = planner.firstActionScores.keys.toList()[option];
      } else {
        selected = planner.getBest();
      }
      print("$actor selects $selected");
      var consequences = selected
          .apply(actor, new PlanConsequence.initial(world), world)
          .toSet();
      var consequence = consequences.first; // Actually pick by random.
      world = consequence.world;
    }
  }
}
