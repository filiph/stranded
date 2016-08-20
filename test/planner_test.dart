//// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
//// is governed by a BSD-style license that can be found in the LICENSE file.
//
//import 'package:stranded/action.dart';
//import 'package:stranded/action_record.dart';
//import 'package:stranded/actor.dart';
//import 'package:stranded/planner.dart';
//import 'package:stranded/world.dart';
//import 'package:test/test.dart';
//
//void main() {
//  group('Planner', () {
//    WorldState world;
//    Actor filip;
//    Iterable<ClosureActorAction> actions;
//
//    setUp(() {
//      filip = new Actor(1, "Filip");
//      var ted = new Actor(100, "Ted");
//      var helen = new Actor(500, "Helen");
//      filip.safetyFear[ted] = new Scale(-0.1);
//      filip.safetyFear[helen] = new Scale(0.5);
//      ted.safetyFear[filip] = new Scale(-0.5);
//      ted.safetyFear[helen] = new Scale(0.0);
//      helen.safetyFear[filip] = new Scale(0.2);
//      helen.safetyFear[ted] = new Scale(-0.5);
//
//      world = new WorldState(new Set.from([filip, ted, helen]));
//
//      actions = defineActions();
//    });
//
//    test("recommends flattering", () {
//      var planner = new ActorPlanner(filip, world, new Set.from(actions));
//
//      planner.plan();
//      var action = planner.getBest();
//      expect(action.toString(), contains("flatter #20"));
//      expect(planner.planConsequencesComputed, greaterThan(50000));
//      expect(planner.planConsequencesComputed, lessThan(100000));
//    });
//  });
//}
//
//Iterable<ClosureActorAction> defineActions() {
//  var sleep = new ClosureActorAction("sleep", (_, __) => true, (actor, world) {
//    return "$actor sleeps";
//  }, null, 1.0);
//
//  String renameSuccess(Actor actor, WorldState world) {
//    actor.name = "Richard";
//    return "$actor renames to Richard";
//  }
//
//  var rename = new ClosureActorAction("rename",
//      (Actor actor, _) => actor.name != "Richard", renameSuccess, null, 0.9);
//
//  String killSuccess(Actor actor, WorldState world) {
//    // TODO: world.removeActor, which also updates actorTurn if needed
//    var target = world.actors.where((a) => a != actor).first;
//    world.actors.remove(target);
//
//    for (var other in world.actors) {
//      if (other.id == actor.id) continue;
//      other.safetyFear[actor].decrease(0.9);
//    }
//    return "$actor killed $target";
//  }
//
//  var kill = new ClosureActorAction(
//      "random kill",
//      (actor, WorldState world) => world.actors.any((a) => a != actor),
//      killSuccess,
//      null /* TODO: add bad pokus o vrazdu */,
//      0.5);
//
//  List<ClosureActorAction> flatters = [];
//  for (int i = 1; i <= 20; i++) {
//    String flatterSuccess(Actor actor, WorldState world) {
//      var target = world.actors.where((a) => a != actor).first;
//      target.safetyFear[actor].increase(i / 20);
//      return "$actor flattered $target";
//    }
//
//    var flatter = new ClosureActorAction(
//        "random flatter #$i",
//        (actor, WorldState world) => world.actors.any((a) => a != actor),
//        flatterSuccess,
//        null,
//        0.8);
//
//    flatters.add(flatter);
//  }
//
//  return new List.from(flatters)..addAll([sleep, rename, kill]);
//}
