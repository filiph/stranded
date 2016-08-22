import 'dart:io';

import 'package:built_collection/built_collection.dart';

import 'package:stranded/actor.dart';
import 'package:stranded/world.dart';
import 'package:stranded/planner.dart';
import 'package:stranded/action.dart';
import 'package:stranded/item.dart';
import 'package:stranded/plan_consequence.dart';
import 'package:stranded/team.dart';
import 'package:stranded/situation.dart';
import 'package:stranded/storyline/randomly.dart';
import 'package:stranded/storyline/storyline.dart';

import 'src/fight/fight_situation.dart';
import 'src/fight/slash.dart';
import 'src/fight/kick.dart';
import 'src/fight/dodge_slash.dart';
import 'src/fight/parry_slash.dart';
import 'src/fight/off_balance_opportunity_thrust.dart';
import 'src/fight/pass.dart';

main() {
  var filip = new Actor((b) => b
    ..id = 1
    ..isPlayer = true
    ..pronoun = Pronoun.YOU
    ..name = "Filip"
    ..currentWeapon = new Sword()
    ..initiative = 1000);
  var grace = new Actor((b) => b
    ..id = 100
    ..pronoun = Pronoun.SHE
    ..name = "Grace"
    ..currentWeapon = new Sword());
  var brant = new Actor((b) => b
    ..id = 500
    ..pronoun = Pronoun.HE
    ..name = "Brant"
    ..currentWeapon = new Sword());

  var orc = new Actor((b) => b
    ..id = 1000
    ..name = "orc"
    ..nameIsProperNoun = false
    ..pronoun = Pronoun.HE
    ..currentWeapon = new Sword()
    ..team = defaultEnemyTeam);

  var goblin = new Actor((b) => b
    ..id = 1001
    ..name = "goblin"
    ..nameIsProperNoun = false
    ..pronoun = Pronoun.HE
    ..currentWeapon = new Sword()
    ..team = defaultEnemyTeam);

  var initialSituation = new Situation.withState(new FightSituation((b) => b
    ..playerTeamIds = new BuiltList<int>([filip.id, grace.id, brant.id])
    ..enemyTeamIds = new BuiltList<int>([orc.id, goblin.id])));

  WorldState world = new WorldState(
      new Set.from([filip, grace, brant, orc, goblin]), initialSituation);

  List<ActorAction> actions = new List<ActorAction>();

  List<ActionGenerator> actionGenerators = new List<ActionGenerator>();
  actionGenerators.add(slashWithSword);
  actionGenerators.add(dodgeSlash);
  actionGenerators.add(parrySlash);
  actionGenerators.add(kickOffBalance);
  actionGenerators.add(offBalanceOpportunityThrust);
  actionGenerators.add(passOpportunity);

//  world.validate();

  var consequence = new PlanConsequence.initial(world);
  var storyline = new Storyline();

  while (world.situations.isNotEmpty) {
    var situation = world.currentSituation;
    var actor = situation.state.getCurrentActor(world);

    var planner = new ActorPlanner(actor, world, actions, actionGenerators);
    planner.plan(maxOrder: 7);

    ActorAction selected;
    if (actor.isPlayer) {
      // Player
      print(storyline.toString());
      storyline.clear();

      planner.generateTable().forEach(print);
      int option = int.parse(stdin.readLineSync());
      selected = planner.firstActionScores.keys.toList()[option];
    } else {
      selected = planner.getBest();
    }
//    print("${actor.name} selects $selected");
    var consequences = selected.apply(actor, consequence, world).toList();
    int index = Randomly
        .chooseWeighted(consequences.map/*<num>*/((c) => c.probability));
    consequence = consequences[index];
    storyline.concatenate(consequence.storyline);
    world = consequence.world;
  }
  print(storyline.toString());
}
