library stranded.actor;

import 'package:quiver/core.dart';
import 'package:stranded/world.dart';
import 'package:collection/collection.dart';

class ActorRelationshipMap extends CanonicalizedMap<int, Actor, Scale> {
  ActorRelationshipMap()
      : super((Actor key) => key.id, isValidKey: (key) => key != null);

  factory ActorRelationshipMap.from(ActorRelationshipMap other) {
    var map = new ActorRelationshipMap();
    other.forEach((Actor key, Scale value) => map[key] = new Scale.from(value));
    return map;
  }

  @override
  int get hashCode {
    return hashObjects(values.toList(growable: false));
  }

  bool operator ==(o) => o is ActorRelationshipMap && hashCode == o.hashCode;
}

class Actor {
  /// Everything else can change, but Actor's [id] can't.
  final int id;
  String name;
  final ActorRelationshipMap gratitudeDislike;

  /// The resources this actor knows about.
  ///
  /// They can share this information with others (or not).
  /// TODO: uncomment and implement
//  final UnmodifiableSetView<LocationResource> knownResources;

  Actor(int id, String name) : this._(id, name, new ActorRelationshipMap());

  Actor._(this.id, this.name, this.gratitudeDislike);

  Actor.from(Actor other) : this._(other.id, other.name,
      new ActorRelationshipMap.from(other.gratitudeDislike));

  @override
  int get hashCode {
    return hash3(id, name, hashObjects(gratitudeDislike.values));
  }

  bool operator ==(o) => o is Actor && id == o.id;

  num scoreWorld(WorldState world) {
    // XXX make subclasses or mixins like EgoisticActor, etc.
    // Current implementation would just love to be alone.
    //return 10 - world.actors.length;

    Iterable<Actor> others = world.actors.where((a) => a != this);
    Iterable<Scale> attitudes = others.map((a) => a.gratitudeDislike[this]);
    num sum = attitudes.fold(0, (prev, el) => prev + el.value);
    return sum / world.actors.length;
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
