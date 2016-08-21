library stranded.situation;

import 'dart:math' show Random;

import 'package:built_value/built_value.dart';

import 'action.dart';
import 'actor.dart';
import 'world.dart';

part 'situation.g.dart';

/// Situation is a phase during play. It governs which actions are available,
/// and what actors can act (and in what order).
///
/// Situations are stacked on a push-down automaton. [Action]s can push new
/// situations on the stack, which are then processed until completion. Actions
/// can also replace the top-most situation with another one, or remove
/// the top-most situation.
///
/// [Situation] wraps around only two fields: the [id] (designed to be constant
/// during the situation's lifetime) and [state]. This is because we want to
/// be able to implement SituationStates easily (there will be a lot of them)
/// and so we we use composition over inheritance. Inheritance in Built values
/// is especially tricky.
///
/// Situations need to be classes (not top-level fields) because they need
/// to be instantiated each time with actor / enemy / time etc.
abstract class Situation implements Built<Situation, SituationBuilder> {
  /// Identifies the situation even after it has changed (for example, the time
  /// has been increased, or an actor has changed).
  int get id;

  SituationState get state;

  Situation._();
  factory Situation([updates(SituationBuilder b)]) = _$Situation;

  factory Situation.withState(SituationState state) =>
      new Situation((b) => b.state = state);

  /// Whitelist of action builders that can be used by actors in this situation.
  ///
  /// When this is `null`, then all actions are allowed.
  ///
  /// TODO: add actionWhitelist?
  Iterable<ActionGenerator> get actionBuilderWhitelist =>
      state.actionBuilderWhitelist;

  void update(WorldState world) {
    state.update(world);
  }

  // TODO: toMap (save [time] as well as currentActor (because we want to make
  //       sure that we load with the same actor although some actors may have
  //       been removed from play))
}

final Random _random = new Random();
final int _largeInteger = 0x3FFFFFFF;

abstract class SituationBuilder
    implements Builder<Situation, SituationBuilder> {
  int id = _random.nextInt(_largeInteger);
  SituationState state;

  SituationBuilder._();
  factory SituationBuilder() = _$SituationBuilder;
}

/// A state of a situation.
abstract class SituationState {
  int get time;

  /// Returns the actor whose turn it is at specified [time].
  Actor getActorAtTime(int time, WorldState world);

  /// Whitelist of action builders that can be used by actors in this situation.
  ///
  /// When this is `null`, then all actions are allowed.
  ///
  /// TODO: add actionWhitelist?
  Iterable<ActionGenerator> get actionBuilderWhitelist => null;

  void update(WorldState world) {
    // No-op by default.
  }

  /// Returns updated state with `time++`.
  SituationState elapseTime();

  /// Filters the [actors] that are active in this situation.
  Iterable<Actor> getActors(Iterable<Actor> actors, WorldState world);

  Actor getCurrentActor(WorldState world) => getActorAtTime(time, world);
}

abstract class ElapsingTime<T, U extends SituationStateBuilderBase> {
  T elapseTime() => rebuild((U b) => b..time += 1);
  T rebuild(updates(U b));
}

abstract class SituationStateBuilderBase {
  int get time;
  set time(int value);
}
