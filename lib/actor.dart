library stranded.actor;

import 'package:quiver/core.dart';
import 'package:stranded/world.dart';
import 'package:collection/collection.dart';
import 'package:stranded/action_record.dart';

class ActorMap<T> extends CanonicalizedMap<int, Actor, T> {
  ActorMap() : super((Actor key) => key.id, isValidKey: (key) => key != null);

  factory ActorMap.from(ActorMap other) {
    var map = new ActorMap<T>();
    other.forEach((Actor key, T value) => map[key] = value);
    return map;
  }

  @override
  int get hashCode {
    return hashObjects(values.toList(growable: false));
  }

  bool operator ==(o) => o is ActorMap && hashCode == o.hashCode;
}

class ActorRelationshipMap extends ActorMap<Scale> {
  ActorRelationshipMap();

  factory ActorRelationshipMap.from(ActorRelationshipMap other) {
    var map = new ActorRelationshipMap();
    other.forEach((Actor key, Scale value) => map[key] = new Scale.from(value));
    return map;
  }
}

//class ActorRelationshipMap extends CanonicalizedMap<int, Actor, Scale> {
//  ActorRelationshipMap()
//      : super((Actor key) => key.id, isValidKey: (key) => key != null);
//
//  factory ActorRelationshipMap.from(ActorRelationshipMap other) {
//    var map = new ActorRelationshipMap();
//    other.forEach((Actor key, Scale value) => map[key] = new Scale.from(value));
//    return map;
//  }
//
//  @override
//  int get hashCode {
//    return hashObjects(values.toList(growable: false));
//  }
//
//  bool operator ==(o) => o is ActorRelationshipMap && hashCode == o.hashCode;
//}

class Actor {
  /// Everything else can change, but Actor's [id] can't.
  final int id;
  String name;

  /// How safe does [this] Actor feel in the presence of the different other
  /// actors.
  ///
  /// For example, a Bob's failed attempt at murder of Alice will lead to Alice
  /// feeling much less safe near Bob. This will greatly decrease her world
  /// score, btw, so this automatically makes an attempted murder something
  /// people don't appreciate.
  final ActorRelationshipMap safetyFear;

  // TODO: loveIndifference
  // other feelings?

  /// The resources this actor knows about.
  ///
  /// They can share this information with others (or not).
  /// TODO: uncomment and implement
//  final UnmodifiableSetView<LocationResource> knownResources;

  Actor(int id, String name) : this._(id, name, new ActorRelationshipMap());

  Actor._(this.id, this.name, this.safetyFear);

  Actor.from(Actor other)
      : this._(other.id, other.name,
            new ActorRelationshipMap.from(other.safetyFear));

  @override
  int get hashCode {
    return hash3(id, name, hashObjects(safetyFear.values));
  }

  bool operator ==(o) => o is Actor && id == o.id;

  num scoreWorld(WorldState world) {
    // XXX make subclasses or mixins like EgoisticActor, etc.

    // People want to feel safe.
    Iterable<Scale> safetyFeelings = safetyFear.values;
    num safetySum = safetyFeelings.fold(0, (prev, el) => prev + el.value);
    num safety = safetySum / world.actors.length;

    // People want to be useful.
    var otherActors = world.actors.where((a) => a.id != id);
    var othersGratitude = otherActors.map((a) => a.getGratitude(this, world));
    num gratitude = othersGratitude.fold(0, (a, b) => a + b);

    return safety + gratitude;
  }

  /// Computes gratitude towards [other] given the state of the [world].
  ///
  /// Goes through action records.
  num getGratitude(Actor other, WorldState world) {
    var othersActions = world.actionRecords.where(
        (rec) => rec.knownTo.contains(id) && rec.protagonist == other.id);

    var scoreChanges = othersActions
        .map((rec) => rec.scoreChange[this])
        .where((value) => value != null);
    num cumulativeScoreChange = scoreChanges.fold(0, (a, b) => a + b);
    return cumulativeScoreChange;
  }

  toString() => "Actor<$name>";
}

class Scale implements Comparable {
  static const num upperBound = 1;
  static const num lowerBound = -1;

  /// The actual value of the scale.
  num get value => _value;
  num _value;

  Scale(this._value) {
    assert(value >= lowerBound && value <= upperBound);
  }

  Scale.from(Scale other) : this(other.value);

  @override
  int get hashCode => (value * 100000000).hashCode;

  bool operator ==(o) => o is Scale && _value == o.value;

  void decrease(num change) {
    _value = lowerBound + (_value - lowerBound) * (1 - change);
  }

  /// Changes the scale so that its [change] percent closer to `1.0`.
  ///
  /// So if [value] is `0` and we call `increase(0.5)`, we get Scale(0.5). If
  /// [value] is `0.5` and we again call `increase(0.5)`, then we get
  /// Scale(0.75).
  void increase(num change) {
    _value = _value + (upperBound - _value) * change;
  }

  String toString() => "Scale($value)";

  @override
  int compareTo(Scale other) => value.compareTo(other.value);
}
