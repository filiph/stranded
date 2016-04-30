library stranded.world;

import 'package:quiver/core.dart';

import 'package:stranded/actor.dart';

class WorldState {
  final Set<Actor> actors;

  WorldState(this.actors);

  /// Creates a deep clone of [other].
  WorldState.from(WorldState other) : actors = new Set<Actor>() {
    actors.addAll(other.actors.map((otherActor) => new Actor.from(otherActor)));
  }

  bool operator ==(o) => o is WorldState && hashCode == o.hashCode;

  @override
  int get hashCode {
    return hashObjects(actors);
  }

  toString() => "World<${actors.toSet()}>";
}