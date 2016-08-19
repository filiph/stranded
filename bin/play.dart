import 'dart:io';

import 'package:built_collection/built_collection.dart';

import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/planner.dart';
import 'package:stranded/action.dart';
import 'package:stranded/item.dart';
import 'package:stranded/plan_consequence.dart';

import 'src/situations/fight/fight_situation.dart';
import 'src/situations/fight/dash.dart';
import 'package:stranded/team.dart';
import 'src/situations/fight/dodge_dash.dart';
import 'package:stranded/situation.dart';

main() {
  var filip = new Actor((b) => b
    ..id = 1
    ..name = "Filip"
    ..currentWeapon = new Sword()
    ..initiative = 1000);
  var sedgwick = new Actor((b) => b
    ..id = 100
    ..name = "Sedgwick"
    ..currentWeapon = new Sword());
  var brant = new Actor((b) => b
    ..id = 500
    ..name = "Brant"
    ..currentWeapon = new Sword());

  var goon = new Actor((b) => b
    ..id = 1000
    ..name = "Goon"
    ..currentWeapon = new Sword()
    ..team = defaultEnemyTeam);

  var initialSituation = new Situation.withState(new FightSituation((b) => b
    ..playerTeam = new BuiltList<Actor>([filip, sedgwick, brant])
    ..enemyTeam = new BuiltList<Actor>([goon])));

  WorldState world = new WorldState(
      new Set.from([filip, sedgwick, brant, goon]), initialSituation);

  Set<ActorAction> actions = new Set<ActorAction>();

  Set<ActionGenerator> actionBuilders = new Set<ActionGenerator>();
  actionBuilders.add(dashWithSword);
  actionBuilders.add(dodgeDash);

//  world.validate();

  var consequence = new PlanConsequence.initial(world);

  while (world.situations.isNotEmpty) {
    var situation = world.currentSituation;
    var actor = situation.state.currentActor;

    List<ActorAction> availableActions;
    if (situation.actionBuilderWhitelist != null) {
      availableActions = situation.actionBuilderWhitelist
          .map((builder) => builder.build(actor, world))
          .expand((x) => x)
          .toList();
    } else {
      availableActions = new List<ActorAction>.from(actions);
      for (var builder in actionBuilders) {
        Iterable<ActorAction> builtActions = builder.build(actor, world);
        availableActions.addAll(builtActions);
      }
    }

    availableActions
        .removeWhere((action) => !action.isApplicable(actor, world));

    var planner = new ActorPlanner(actor, world, availableActions);
    print("Planning for ${actor.name}");
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
    print("${actor.name} selects $selected");
    var consequences = selected.apply(actor, consequence, world).toSet();
    consequence = consequences.first; // TODO: Actually pick by random.
    world = consequence.world;
  }
}
