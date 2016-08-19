// GENERATED CODE - DO NOT MODIFY BY HAND

part of stranded.fight.dash_situation;

// **************************************************************************
// Generator: BuiltValueGenerator
// Target: abstract class DashSituation
// **************************************************************************

class _$DashSituation extends DashSituation {
  final int time;
  final Actor attacker;
  final Actor target;
  _$DashSituation._({this.time, this.attacker, this.target}) : super._() {
    if (time == null) throw new ArgumentError('null time');
    if (attacker == null) throw new ArgumentError('null attacker');
    if (target == null) throw new ArgumentError('null target');
  }
  factory _$DashSituation([updates(DashSituationBuilder b)]) =>
      (new DashSituationBuilder()..update(updates)).build();
  DashSituation rebuild(updates(DashSituationBuilder b)) =>
      (toBuilder()..update(updates)).build();
  _$DashSituationBuilder toBuilder() =>
      new _$DashSituationBuilder()..replace(this);
  bool operator ==(other) {
    if (other is! DashSituation) return false;
    return time == other.time &&
        attacker == other.attacker &&
        target == other.target;
  }

  int get hashCode {
    return hashObjects([time, attacker, target]);
  }

  String toString() {
    return 'DashSituation {'
        'time=${time.toString()}\n'
        'attacker=${attacker.toString()}\n'
        'target=${target.toString()}\n'
        '}';
  }
}

class _$DashSituationBuilder extends DashSituationBuilder {
  _$DashSituationBuilder() : super._();
  void replace(DashSituation other) {
    super.time = other.time;
    super.attacker = other.attacker;
    super.target = other.target;
  }

  void update(updates(DashSituationBuilder b)) {
    if (updates != null) updates(this);
  }

  DashSituation build() {
    if (time == null) throw new ArgumentError('null time');
    if (attacker == null) throw new ArgumentError('null attacker');
    if (target == null) throw new ArgumentError('null target');
    return new _$DashSituation._(
        time: time, attacker: attacker, target: target);
  }
}
