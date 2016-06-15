library stranded.actor;

import 'package:quiver/core.dart';
import 'package:stranded/world.dart';
import 'package:collection/collection.dart';
import 'package:stranded/action_record.dart';
import 'package:stranded/item.dart';
import 'package:stranded/util/duplicate_set.dart';

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

  factory ActorRelationshipMap.duplicate(ActorRelationshipMap other) {
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

  final Set<Item> items;

  // TODO: loveIndifference
  // other feelings?

  /// The resources this actor knows about.
  ///
  /// They can share this information with others (or not).
  /// TODO: uncomment and implement
//  final UnmodifiableSetView<LocationResource> knownResources;

  Actor(int id, String name)
      : this._(id, name, new ActorRelationshipMap(), new Set());

  Actor._(this.id, this.name, this.safetyFear, this.items);

  factory Actor.duplicate(Actor other) {
    var items =
        duplicateSet/*<Item>*/(other.items, (item) => new Item.duplicate(item));
    var actor = new Actor._(other.id, other.name,
        new ActorRelationshipMap.duplicate(other.safetyFear), items);
    return actor;
  }

  @override
  int get hashCode {
    return hash4(id, name, hashObjects(safetyFear.values), hashObjects(items));
  }

  bool operator ==(o) => o is Actor && id == o.id;

  /// Scores the state of the [world] in the eyes of [this] Actor.
  ///
  /// This is the "objective function" that the actors try to optimize.
  /// Presumably, different characters will score the same situation
  /// differently, and of course the same world will be scored differently
  /// depending on who scores it (if Bob has all the bananas and Alice is
  /// starving, then Bob's score will be higher than Alice's).
  ///
  /// By default, actor scores the world according to what he or she currently
  /// knows about it. Setting [allKnowing] to `true` will override that
  /// behavior. This is important when gauging the effects of [ActionRecord].
  /// If Bob destroys a fountain in a location not known to Alice, we still want
  /// the action record to mark this as something that Alice won't like when
  /// someone tells her about it later. So, when building the ActionRecord,
  /// we override the fact that Alice didn't know about the location.
  ///
  /// TODO: let author define the actor's character and use it here (optimist,
  ///       egoist, altruist, ...)
  num scoreWorld(WorldState world, {bool allKnowing: false}) {
    // People want to feel safe.
    Iterable<Scale> safetyFeelings = safetyFear.values;
    num safetySum = safetyFeelings.fold(0, (prev, el) => prev + el.value);
    num safety = safetySum / world.actors.length;

    // People want to be useful.
    var otherActors = world.actors.where((a) => a.id != id);
    var othersGratitude = otherActors.map((a) => a.getGratitude(this, world));
    num gratitudeSum = othersGratitude.fold(0, (a, b) => a + b);
    num gratitude = gratitudeSum / world.actors.length;

    // People want luxury
    Map<ItemType, num> itemScores = new Map<ItemType, num>();
    for (var item in items) {
      num runningScore = itemScores.putIfAbsent(item.type, () => 0);
      if (item.luxuryIsCumulative) {
        itemScores[item.type] = runningScore + item.luxuryScore;
      } else {
        itemScores[item.type] =
            item.luxuryScore > runningScore ? item.luxuryScore : runningScore;
      }
    }

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

  Item removeItem(Type type) {
    Item markedForRemoval;
    for (var item in items) {
      if (item.runtimeType == type) {
        markedForRemoval = item;
        break;
      }
    }
    if (markedForRemoval == null) {
      throw new StateError("Cannot remove item: actor $this doesn't have "
          "$type");
    }
    items.remove(markedForRemoval);
    return markedForRemoval;
  }

  Iterable<Item> removeItems(Type type, int count) {
    var markedForRemoval = <Item>[];
    int remaining = count;
    for (var item in items) {
      if (item.runtimeType == type) {
        markedForRemoval.add(item);
      }
      remaining -= 1;
      if (remaining <= 0) break;
    }
    if (remaining != 0) {
      throw new StateError("Cannot remove $count items of $type from $this. "
          "Only ${count - remaining} in possession.");
    }
    markedForRemoval.forEach((item) => items.remove(item));
    return markedForRemoval;
  }

  bool hasItem(Type type, {int count: 1}) {
    for (var item in items) {
      if (item.runtimeType == type) {
        count -= 1;
      }
      if (count <= 0) break;
    }
    return count <= 0;
  }
}

class Scale implements Comparable<Scale> {
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
