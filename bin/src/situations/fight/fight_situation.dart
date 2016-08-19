import 'package:built_collection/built_collection.dart';

import 'package:stranded/situation.dart';
import 'package:stranded/actor.dart';
import 'package:quiver/core.dart';

class FightSituation extends Situation {
  final BuiltList<Actor> playerTeam;
  final BuiltList<Actor> enemyTeam;

  FightSituation(this.playerTeam, this.enemyTeam, {int time: 0}) : super(time);

  @override
  Situation clone() => new FightSituation(
      playerTeam,
      enemyTeam,
      time: time);

  @override
  int get hashCode => hash2(hashObjects(playerTeam), hashObjects(enemyTeam));

  @override
  Actor getActorAtTime(int i) {
    // TODO: add _lastActor and use that to offset [i] if needed (when one of
    //       the actors is removed during the fight.
    if (i % 2 == 0) {
      return playerTeam[(i ~/ 2) % playerTeam.length];
    } else {
      return enemyTeam[((i - 1) ~/ 2) % enemyTeam.length];
    }
  }

  @override
  Iterable<Actor> getActors(Iterable<Actor> actors) => actors.where(
      (actor) => playerTeam.contains(actor) || enemyTeam.contains(actor));
}
