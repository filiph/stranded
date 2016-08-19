library stranded.situation;

import 'action.dart';
import 'actor.dart';

/// Situation is a phase during play. It governs which actions are available,
/// and what actors can act (and in what order).
///
/// Situations are stacked on a push-down automaton. [Action]s can push new
/// situations on the stack, which are then process until completion. Actions
/// can also replace the top-most situation with another one, or remove
/// the top-most situation.
///
/// Situations need to be classes (not top-level fields) because they need
/// to be instantiated each time with actor / enemy / time etc.
abstract class Situation {
  int time = 0;

  Situation(this.time);

  /// Whitelist of action builders that can be used by actors in this situation.
  ///
  /// When this is `null`, then all actions are allowed.
  ///
  /// TODO: add actionWhitelist?
  Iterable<ActionGenerator> get actionBuilderWhitelist => null;

  /// Filters the [actors] that are active in this situation.
  Iterable<Actor> getActors(Iterable<Actor> actors);

  /// Returns the actor whose turn it is at specified [time].
  Actor getActorAtTime(int i);

  void elapseTime() {
    time += 1;
  }

  Actor get currentActor => getActorAtTime(time);

  bool operator==(other) => other is Situation && other.hashCode == hashCode;

  int get hashCode => throw new UnimplementedError("Situations need to provide "
      "their own hashCode.");

  // TODO: toMap (save [time] as well as currentActor (because we want to make
  //       sure that we load with the same actor although some actors may have
  //       been removed from play))

  Situation clone();
}
