import 'dart:io';

import 'package:quiver/iterables.dart';

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

main() {
  var filip = new Actor(1, "Filip", initiative: 1000);
  var sedgwick = new Actor(100, "Sedgwick");
  var brant = new Actor(500, "Brant");
  filip.safetyFear[sedgwick] = new Scale(-0.1);
  filip.safetyFear[brant] = new Scale(0.5);
  sedgwick.safetyFear[filip] = new Scale(-0.5);
  sedgwick.safetyFear[brant] = new Scale(0.0);
  brant.safetyFear[filip] = new Scale(0.2);
  brant.safetyFear[sedgwick] = new Scale(-0.5);

  var goon = new Actor(1000, "Goon", team: defaultEnemyTeam);

  List<Actor> actors = <Actor>[filip, sedgwick, brant, goon];
  actors.forEach((actor) => actor.currentWeapon = new Sword());

  var initialSituation = new FightSituation([filip, sedgwick, brant], [goon]);

  WorldState world = new WorldState(new Set.from(actors), initialSituation);

  Set<ActorAction> actions = new Set<ActorAction>();

  Set<ActionBuilder> actionBuilders = new Set<ActionBuilder>();
  actionBuilders.add(dashWithSword);
  actionBuilders.add(dodgeDash);

//  world.validate();

  var consequence = new PlanConsequence.initial(world);

  while (world.situations.isNotEmpty) {
    var situation = world.currentSituation;
    var actor = situation.currentActor;

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
    var consequences = selected.apply(actor, consequence, world).toSet();
    consequence = consequences.first; // TODO: Actually pick by random.
//    XXX START HERE: random!
    world = consequence.world;
  }
}
