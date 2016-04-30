// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:stranded/action.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/planner.dart';
import 'package:stranded/world.dart';
import 'package:test/test.dart';

void main() {
  group('Planner', () {
    WorldState world;
    Actor filip;
    Iterable<DebugActorAction> actions;

    setUp(() {
      filip = new Actor(1, "Filip");
      var ted = new Actor(100, "Ted");
      var helen = new Actor(500, "Helen");
      filip.gratitudeDislike[ted] = new Scale(-0.1);
      filip.gratitudeDislike[helen] = new Scale(0.5);
      ted.gratitudeDislike[filip] = new Scale(-0.5);
      ted.gratitudeDislike[helen] = new Scale(0.0);
      helen.gratitudeDislike[filip] = new Scale(0.2);
      helen.gratitudeDislike[ted] = new Scale(-0.5);

      world = new WorldState(new Set.from([filip, ted, helen]));

      actions = defineActions();
    });

    test("recommends flattering", () {
      var planner = new ActorPlanner(filip, world, new Set.from(actions));

      planner.plan();
      var action = planner.getBest();
      expect(action.toString(), contains("flatter #20"));
      expect(planner.planConsequencesComputed, greaterThan(50000));
      expect(planner.planConsequencesComputed, lessThan(100000));
    });
  });
}

Iterable<DebugActorAction> defineActions() {
  var sleep = new DebugActorAction("sleep", (_, __) => true,
      (actor, world) => world, null, 1.0);

  void renameSuccess(Actor actor, WorldState world) {
    actor.name = "Richard";
  }

  var rename = new DebugActorAction(
      "rename",
      (Actor actor, _) => actor.name != "Richard",
      renameSuccess,
      null,
      0.9);

  void killSuccess(Actor actor, WorldState world) {
    var target = world.actors.where((a) => a != actor).first;
    world.actors.remove(target);
    for (var other in world.actors.toList()) {
      if (other == actor) continue;
      other.gratitudeDislike[actor].decrease(0.9);
    }
  }

  var kill = new DebugActorAction(
      "random kill",
      (actor, WorldState world) => world.actors.any((a) => a != actor),
      killSuccess,
      null /* TODO: add bad pokus o vrazdu */,
      0.5);

  List<DebugActorAction> flatters = [];
  for (int i = 1; i <= 20; i++) {
    void flatterSuccess(Actor actor, WorldState world) {
      var target = world.actors.where((a) => a != actor).first;
      target.gratitudeDislike[actor].increase(i / 20);
    }

    var flatter = new DebugActorAction(
        "random flatter #$i",
        (actor, WorldState world) => world.actors.any((a) => a != actor),
        flatterSuccess,
        null,
        0.8);

    flatters.add(flatter);
  }

  return new List.from(flatters)..addAll([sleep, rename, kill]);
}
