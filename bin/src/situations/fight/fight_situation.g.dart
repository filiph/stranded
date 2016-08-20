// GENERATED CODE - DO NOT MODIFY BY HAND

part of stranded.fight.fight_situation;

// **************************************************************************
// Generator: BuiltValueGenerator
// Target: abstract class FightSituation
// **************************************************************************

class _$FightSituation extends FightSituation {
  final int time;
  final BuiltList<int> playerTeamIds;
  final BuiltList<int> enemyTeamIds;
  _$FightSituation._({this.time, this.playerTeamIds, this.enemyTeamIds})
      : super._() {
    if (time == null) throw new ArgumentError('null time');
    if (playerTeamIds == null) throw new ArgumentError('null playerTeamIds');
    if (enemyTeamIds == null) throw new ArgumentError('null enemyTeamIds');
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
        playerTeamIds == other.playerTeamIds &&
        enemyTeamIds == other.enemyTeamIds;
  }

  int get hashCode {
    return hashObjects([time, playerTeamIds, enemyTeamIds]);
  }

  String toString() {
    return 'FightSituation {'
        'time=${time.toString()}\n'
        'playerTeamIds=${playerTeamIds.toString()}\n'
        'enemyTeamIds=${enemyTeamIds.toString()}\n'
        '}';
  }
}

class _$FightSituationBuilder extends FightSituationBuilder {
  _$FightSituationBuilder() : super._();
  void replace(FightSituation other) {
    super.time = other.time;
    super.playerTeamIds = other.playerTeamIds;
    super.enemyTeamIds = other.enemyTeamIds;
  }

  void update(updates(FightSituationBuilder b)) {
    if (updates != null) updates(this);
  }

  FightSituation build() {
    if (time == null) throw new ArgumentError('null time');
    if (playerTeamIds == null) throw new ArgumentError('null playerTeamIds');
    if (enemyTeamIds == null) throw new ArgumentError('null enemyTeamIds');
    return new _$FightSituation._(
        time: time, playerTeamIds: playerTeamIds, enemyTeamIds: enemyTeamIds);
  }
}
