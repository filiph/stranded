import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:built_value_generator/built_value_generator.dart';

final phases = new PhaseGroup.singleAction(
    new GeneratorBuilder([new BuiltValueGenerator()]),
    new InputSet('stranded', const [
      'lib/actor.dart',
      'lib/situation.dart',
      'lib/team.dart',
      'bin/src/fight/fight_situation.dart',
      'bin/src/fight/off_balance_opportunity_situation.dart',
      'bin/src/fight/slash_defense_situation.dart',
      'bin/src/fight/slash_situation.dart',
    ]));
