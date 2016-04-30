library stranded.world;

import 'package:quiver/core.dart';

import 'package:stranded/actor.dart';
import 'package:stranded/action_record.dart';

class WorldState {
  final Set<Actor> actors;
  final Set<ActionRecord> actionRecords;

  WorldState(this.actors) : actionRecords = new Set();

  /// Creates a deep clone of [other].
  WorldState.from(WorldState other)
      : actors = new Set<Actor>(),
        actionRecords = new Set<ActionRecord>() {
    actors.addAll(other.actors.map((otherActor) => new Actor.from(otherActor)));
    actionRecords.addAll(other.actionRecords
        .map((otherRecord) => new ActionRecord.from(otherRecord)));
  }

  ActorMap<num> getActorScores() {
    final result = new ActorMap<num>();
    for (var a in actors) {
      result[a] = a.scoreWorld(this);
    }
    return result;
  }

  bool operator ==(o) => o is WorldState && hashCode == o.hashCode;

  @override
  int get hashCode {
    return hash2(hashObjects(actors), hashObjects(actionRecords));
  }

  toString() => "World<${actors.toSet()}>";
}
