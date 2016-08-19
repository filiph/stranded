// GENERATED CODE - DO NOT MODIFY BY HAND

part of stranded.fight.fight_situation;

// **************************************************************************
// Generator: BuiltValueGenerator
// Target: abstract class FightSituation
// **************************************************************************

class _$FightSituation extends FightSituation {
  final int time;
  final BuiltList<Actor> playerTeam;
  final BuiltList<Actor> enemyTeam;
  _$FightSituation._({this.time, this.playerTeam, this.enemyTeam}) : super._() {
    if (time == null) throw new ArgumentError('null time');
    if (playerTeam == null) throw new ArgumentError('null playerTeam');
    if (enemyTeam == null) throw new ArgumentError('null enemyTeam');
  }
  factory _$FightSituation([updates(FightSituationBuilder b)]) =>
      (new FightSituationBuilder()..update(updates)).build();
  FightSituation rebuild(updates(FightSituationBuilder b)) =>
      (toBuilder()..update(updates)).build();
  _$FightSituationBuilder toBuilder() =>
      new _$FightSituationBuilder()..replace(this);
  bool operator ==(other) {
    if (other is! FightSituation) return false;
    return time == other.time &&
        playerTeam == other.playerTeam &&
        enemyTeam == other.enemyTeam;
  }

  int get hashCode {
    return hashObjects([time, playerTeam, enemyTeam]);
  }

  String toString() {
    return 'FightSituation {'
        'time=${time.toString()}\n'
        'playerTeam=${playerTeam.toString()}\n'
        'enemyTeam=${enemyTeam.toString()}\n'
        '}';
  }
}

class _$FightSituationBuilder extends FightSituationBuilder {
  _$FightSituationBuilder() : super._();
  void replace(FightSituation other) {
    super.time = other.time;
    super.playerTeam = other.playerTeam;
    super.enemyTeam = other.enemyTeam;
  }

  void update(updates(FightSituationBuilder b)) {
    if (updates != null) updates(this);
  }

  FightSituation build() {
    if (time == null) throw new ArgumentError('null time');
    if (playerTeam == null) throw new ArgumentError('null playerTeam');
    if (enemyTeam == null) throw new ArgumentError('null enemyTeam');
    return new _$FightSituation._(
        time: time, playerTeam: playerTeam, enemyTeam: enemyTeam);
  }
}
