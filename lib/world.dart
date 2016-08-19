library stranded.world;

import 'package:quiver/core.dart';

import 'package:stranded/action_record.dart';
import 'package:stranded/actor.dart';
import 'package:stranded/item.dart';
import 'package:stranded/location.dart';
import 'package:stranded/situation.dart';

class WorldState {
  final Set<Actor> actors;
  final Set<Item> items;
  final Set<ActionRecord> actionRecords;
  final Set<Location> locations;

  /// A stack of situations. The top-most (first) one is the [currentSituation].
  ///
  /// This is a push-down automaton.
  final List<Situation> situations;

  Situation get currentSituation => situations.last;

  /// The age of this WorldState. Every 'turn', this number increases by one.
  int time;

  WorldState(this.actors, Situation startingSituation)
      : actionRecords = new Set(),
        items = new Set(),
        locations = new Set(),
        situations = new List.from([startingSituation]),
        time = 0;

  /// Creates a deep clone of [other].
  WorldState.duplicate(WorldState other)
      : actors = new Set<Actor>(),
        actionRecords = new Set<ActionRecord>(),
        items = new Set<Item>(),
        locations = new Set(),
        situations = new List() {
    actors.addAll(other.actors);
    // TODO: duplicateActionRecord, item, etc.
    actionRecords.addAll(other.actionRecords
        .map((otherRecord) => new ActionRecord.duplicate(otherRecord)));
    items.addAll(other.items);
    locations.addAll(other.locations
        .map((otherLocation) => new Location.duplicate(otherLocation)));
    situations.addAll(other.situations);

    time = other.time;
  }

  Actor getActorById(int id) => actors.singleWhere((actor) => actor.id == id);

  void updateActorById(int id, updates(ActorBuilder b)) {
    var original = getActorById(id);
    var updated = original.rebuild(updates);
    actors.remove(original);
    actors.add(updated);
  }

  void updateSituationById(int id, updates(SituationBuilder b)) {
    int index;
    for (int i = 0; i < situations.length; i++) {
      if (situations[i].id == id) {
        index = i;
        break;
      }
    }
    if (index == null) return;

    situations[index] = situations[index].rebuild((updates));
  }

  void elapseTime() {
    time += 1;
  }

  @override
  int get hashCode {
    return hash4(hashObjects(actors), hashObjects(actionRecords),
        hashObjects(situations), time);
  }

  bool operator ==(o) => o is WorldState && hashCode == o.hashCode;

  toString() => "World<${actors.toSet()}>";

  void pushSituation(Situation situation) {
    situations.add(situation);
  }

  void popSituation() {
    situations.removeLast();
  }
}
