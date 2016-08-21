// GENERATED CODE - DO NOT MODIFY BY HAND

part of stranded.fight.off_balance_situation;

// **************************************************************************
// Generator: BuiltValueGenerator
// Target: abstract class OffBalanceSituation
// **************************************************************************

class _$OffBalanceSituation extends OffBalanceSituation {
  final int time;
  final int actorId;
  _$OffBalanceSituation._({this.time, this.actorId}) : super._() {
    if (time == null) throw new ArgumentError('null time');
    if (actorId == null) throw new ArgumentError('null actorId');
  }
  factory _$OffBalanceSituation([updates(OffBalanceSituationBuilder b)]) =>
      (new OffBalanceSituationBuilder()..update(updates)).build();
  OffBalanceSituation rebuild(updates(OffBalanceSituationBuilder b)) =>
      (toBuilder()..update(updates)).build();
  _$OffBalanceSituationBuilder toBuilder() =>
      new _$OffBalanceSituationBuilder()..replace(this);
  bool operator ==(other) {
    if (other is! OffBalanceSituation) return false;
    return time == other.time && actorId == other.actorId;
  }

  int get hashCode {
    return hashObjects([time, actorId]);
  }

  String toString() {
    return 'OffBalanceSituation {'
        'time=${time.toString()}\n'
        'actorId=${actorId.toString()}\n'
        '}';
  }
}

class _$OffBalanceSituationBuilder extends OffBalanceSituationBuilder {
  _$OffBalanceSituationBuilder() : super._();
  void replace(OffBalanceSituation other) {
    super.time = other.time;
    super.actorId = other.actorId;
  }

  void update(updates(OffBalanceSituationBuilder b)) {
    if (updates != null) updates(this);
  }

  OffBalanceSituation build() {
    if (time == null) throw new ArgumentError('null time');
    if (actorId == null) throw new ArgumentError('null actorId');
    return new _$OffBalanceSituation._(time: time, actorId: actorId);
  }
}
