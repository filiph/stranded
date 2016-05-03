// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'package:stranded/world.dart';
import 'package:stranded/actor.dart';

void main() {
  group('World', () {
    WorldState world;

    setUp(() {
      var filip = new Actor(1, "Filip");
      var ted = new Actor(100, "Ted");
      var helen = new Actor(500, "Helen");
      filip.safetyFear[ted] = new Scale(-0.1);
      filip.safetyFear[helen] = new Scale(0.5);
      ted.safetyFear[filip] = new Scale(-0.5);
      ted.safetyFear[helen] = new Scale(0.0);
      helen.safetyFear[filip] = new Scale(0.2);
      helen.safetyFear[ted] = new Scale(-0.5);

      world = new WorldState(new Set.from([filip, ted, helen]));
    });

    test("hashCode stays the same", () {
      int hash = world.hashCode;
      var newWorld = new WorldState.from(world);
      expect(newWorld.hashCode, hash);
    });

    test("hashCode changes on name changes", () {
      int hash = world.hashCode;
      world.actors.first.name = "Jelitník";
      expect(world.hashCode, isNot(hash));
    });

    test("hashCode changes on removed actor", () {
      int hash = world.hashCode;
      var nextWorld = new WorldState.from(world);
      nextWorld.actors.remove(nextWorld.actors.first);
      expect(nextWorld.hashCode, isNot(hash));
    });

    test("hashCode changes on relationship changes (increase)", () {
      int hash = world.hashCode;
      world.actors.first.safetyFear[world.actors.last].increase(0.5);
      expect(world.hashCode, isNot(hash));
    });

    test("hashCode changes on relationship changes (decrease)", () {
      int hash = world.hashCode;
      world.actors.last.safetyFear[world.actors.first].decrease(0.1);
      expect(world.hashCode, isNot(hash));
    });
  });

  group('ActorRelationshipMap', () {
    ActorRelationshipMap map;

    setUp(() {
      map = new ActorRelationshipMap();
      var filip = new Actor(1, "Filip");
      var ted = new Actor(100, "Ted");
      var helen = new Actor(500, "Helen");

      map[filip] = new Scale(-0.5);
      map[ted] = new Scale(-0.1);
      map[helen] = new Scale(0.5);
    });

    test("hashCode doesn't compute to 0", () {
      int hash = map.hashCode;
      expect(hash, isNot(0));
    });

    test("hashCode stays the same for equivalent maps", () {
      int hash = map.hashCode;
      var newMap = new ActorRelationshipMap.from(map);
      expect(newMap.hashCode, hash);
    });

    test("hashCode changes when a since scale is changed", () {
      int hash = map.hashCode;
      map.values.first.increase(0.5);
      expect(map.hashCode, isNot(hash));
    });
  });
}
