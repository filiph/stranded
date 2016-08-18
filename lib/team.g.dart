// GENERATED CODE - DO NOT MODIFY BY HAND

part of stranded.team;

// **************************************************************************
// Generator: BuiltValueGenerator
// Target: abstract class Team
// **************************************************************************

class _$Team extends Team {
  final int id;
  _$Team._({this.id}) : super._() {
    if (id == null) throw new ArgumentError('null id');
  }
  factory _$Team([updates(TeamBuilder b)]) =>
      (new TeamBuilder()..update(updates)).build();
  Team rebuild(updates(TeamBuilder b)) =>
      (toBuilder()..update(updates)).build();
  _$TeamBuilder toBuilder() => new _$TeamBuilder()..replace(this);
  bool operator ==(other) {
    if (other is! Team) return false;
    return id == other.id;
  }

  int get hashCode {
    return hashObjects([id]);
  }

  String toString() {
    return 'Team {'
        'id=${id.toString()}\n'
        '}';
  }
}

class _$TeamBuilder extends TeamBuilder {
  _$TeamBuilder() : super._();
  void replace(Team other) {
    super.id = other.id;
  }

  void update(updates(TeamBuilder b)) {
    if (updates != null) updates(this);
  }

  Team build() {
    if (id == null) throw new ArgumentError('null id');
    return new _$Team._(id: id);
  }
}
