// GENERATED CODE - DO NOT MODIFY BY HAND

part of stranded.situation;

// **************************************************************************
// Generator: BuiltValueGenerator
// Target: abstract class Situation
// **************************************************************************

class _$Situation extends Situation {
  final int id;
  final SituationState state;
  _$Situation._({this.id, this.state}) : super._() {
    if (id == null) throw new ArgumentError('null id');
    if (state == null) throw new ArgumentError('null state');
  }
  factory _$Situation([updates(SituationBuilder b)]) =>
      (new SituationBuilder()..update(updates)).build();
  Situation rebuild(updates(SituationBuilder b)) =>
      (toBuilder()..update(updates)).build();
  _$SituationBuilder toBuilder() => new _$SituationBuilder()..replace(this);
  bool operator ==(other) {
    if (other is! Situation) return false;
    return id == other.id && state == other.state;
  }

  int get hashCode {
    return hashObjects([id, state]);
  }

  String toString() {
    return 'Situation {'
        'id=${id.toString()}\n'
        'state=${state.toString()}\n'
        '}';
  }
}

class _$SituationBuilder extends SituationBuilder {
  _$SituationBuilder() : super._();
  void replace(Situation other) {
    super.id = other.id;
    super.state = other.state;
  }

  void update(updates(SituationBuilder b)) {
    if (updates != null) updates(this);
  }

  Situation build() {
    if (id == null) throw new ArgumentError('null id');
    if (state == null) throw new ArgumentError('null state');
    return new _$Situation._(id: id, state: state);
  }
}
