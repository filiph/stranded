library stranded.action_record;

import 'package:collection/collection.dart';
import 'package:stranded/actor.dart';

/// A record of some event action that transpired.
///
/// Every action gets ActionRecord which says who did that action (some strings
/// like '<subject> built a shelter'), who knows about it, and how that action
/// changed everyone's worldScore (or _would have changed_ worldScore if that
/// person knew about it).
///
/// SpecialEvent (monkeys steal food) is a type of ActorAction (where
/// `performers == null`) that also get ActionRecords.
///
/// Everyone's stance towards everyone else is computed by:
///
/// - getting default stance (0.0)
/// - applying personal bias (optimist, pesimist)
/// - applying all `ActionRecord`s that the subject knows about that the other
///   person is responsible for


int _extractId(Actor actor) => actor.id;

class ActionRecord {
  final String description;

  /// The actors responsible for this action, or an empty set if this is an
  /// environmental event (monkeys steal stuff).
  ///
  /// Actors are represented by their [Actor.id] since we only care about
  /// their identity, not their state at the time of action.
  final Set<int> performers;

  /// The actors who know about this.
  ///
  /// Actors are represented by their [Actor.id] since we only care about
  /// their identity, not their state at the time of action.
  final Set<int> knownTo;

  /// The changes to worldScore of the different people, regardless whether they
  /// know about it or not (we pretend they do, and see how that affects
  /// things).
  ///
  /// Actors are represented by their [Actor.id] since we only care about
  /// their identity, not their state at the time of action.
  final Map<int, num> benefits;

  ActionRecord(this.description, Iterable<Actor> performers,
      Iterable<Actor> knownTo, Map<Actor, num> benefits)
      : performers = performers.map(_extractId),
        knownTo = knownTo.map(_extractId),
        benefits = new Map.fromIterables(
            benefits.keys.map(_extractId), benefits.values);
}
