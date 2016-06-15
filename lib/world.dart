library stranded.world;

import 'package:quiver/core.dart';
import 'package:stranded/action_record.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/item.dart';
import 'package:stranded/location.dart';

class WorldState {
  final Set<Actor> actors;
  final Set<Item> items;
  final Set<ActionRecord> actionRecords;
  final Set<Location> locations;

  WorldState(this.actors)
      : actionRecords = new Set(),
        items = new Set(),
        locations = new Set();

  /// Creates a deep clone of [other].
  WorldState.duplicate(WorldState other)
      : actors = new Set<Actor>(),
        actionRecords = new Set<ActionRecord>(),
        items = new Set<Item>(),
        locations = new Set() {
    actors.addAll(
        other.actors.map((otherActor) => new Actor.duplicate(otherActor)));
    actionRecords.addAll(other.actionRecords
        .map((otherRecord) => new ActionRecord.duplicate(otherRecord)));
    items.addAll(other.items.map((otherItem) => new Item.duplicate(otherItem)));
    locations.addAll(other.locations
        .map((otherLocation) => new Location.duplicate(otherLocation)));
  }

  @override
  int get hashCode {
    return hash2(hashObjects(actors), hashObjects(actionRecords));
  }

  bool operator ==(o) => o is WorldState && hashCode == o.hashCode;

  toString() => "World<${actors.toSet()}>";

  /// Checks integrity of the world.
  ///
  /// Run this just after you set up the world with actors and before you
  /// do any simulation.
  void validate() {
    void setsAreSame(Set a, Set b, String type) {
      var aButNotB = a.difference(b);
      if (aButNotB.isNotEmpty) {
        throw new StateError(
            "Bad world: $type set $a has members $aButNotB that are not in $b");
      }
      var bButNotA = b.difference(a);
      if (bButNotA.isNotEmpty) {
        throw new StateError(
            "Bad world: $type set $b has members $bButNotA that are not in $a");
      }
    }

    for (var actor in actors) {
      setsAreSame(actor.safetyFear.keys.toSet(),
          actors.where((a) => a != actor).toSet(), "safetyFear");
    }
  }
}
