// GENERATED CODE - DO NOT MODIFY BY HAND

part of stranded.actor;

// **************************************************************************
// Generator: BuiltValueGenerator
// Target: abstract class Actor
// **************************************************************************

class _$Actor extends Actor {
  final int id;
  final String name;
  final Team team;
  final Set<Item> items;
  final Item currentWeapon;
  final int health;
  final int initiative;
  _$Actor._(
      {this.id,
      this.name,
      this.team,
      this.items,
      this.currentWeapon,
      this.health,
      this.initiative})
      : super._() {
    if (id == null) throw new ArgumentError('null id');
    if (name == null) throw new ArgumentError('null name');
    if (team == null) throw new ArgumentError('null team');
    if (items == null) throw new ArgumentError('null items');
    if (health == null) throw new ArgumentError('null health');
    if (initiative == null) throw new ArgumentError('null initiative');
  }
  factory _$Actor([updates(ActorBuilder b)]) =>
      (new ActorBuilder()..update(updates)).build();
  Actor rebuild(updates(ActorBuilder b)) =>
      (toBuilder()..update(updates)).build();
  _$ActorBuilder toBuilder() => new _$ActorBuilder()..replace(this);
  bool operator ==(other) {
    if (other is! Actor) return false;
    return id == other.id &&
        name == other.name &&
        team == other.team &&
        items == other.items &&
        currentWeapon == other.currentWeapon &&
        health == other.health &&
        initiative == other.initiative;
  }

  int get hashCode {
    return hashObjects(
        [id, name, team, items, currentWeapon, health, initiative]);
  }

  String toString() {
    return 'Actor {'
        'id=${id.toString()}\n'
        'name=${name.toString()}\n'
        'team=${team.toString()}\n'
        'items=${items.toString()}\n'
        'currentWeapon=${currentWeapon.toString()}\n'
        'health=${health.toString()}\n'
        'initiative=${initiative.toString()}\n'
        '}';
  }
}

class _$ActorBuilder extends ActorBuilder {
  _$ActorBuilder() : super._();
  void replace(Actor other) {
    super.id = other.id;
    super.name = other.name;
    super.team = other.team;
    super.items = other.items;
    super.currentWeapon = other.currentWeapon;
    super.health = other.health;
    super.initiative = other.initiative;
  }

  void update(updates(ActorBuilder b)) {
    if (updates != null) updates(this);
  }

  Actor build() {
    if (id == null) throw new ArgumentError('null id');
    if (name == null) throw new ArgumentError('null name');
    if (team == null) throw new ArgumentError('null team');
    if (items == null) throw new ArgumentError('null items');
    if (health == null) throw new ArgumentError('null health');
    if (initiative == null) throw new ArgumentError('null initiative');
    return new _$Actor._(
        id: id,
        name: name,
        team: team,
        items: items,
        currentWeapon: currentWeapon,
        health: health,
        initiative: initiative);
  }
}
