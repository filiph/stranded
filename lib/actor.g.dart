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
  final bool alreadyMentioned;
  final bool isActive;
  final Pronoun pronoun;
  final List<String> categories;
  final bool isAlive;
  final bool isPlayer;
  final bool nameIsProperNoun;
  final int initiative;
  _$Actor._(
      {this.id,
      this.name,
      this.team,
      this.items,
      this.currentWeapon,
      this.health,
      this.alreadyMentioned,
      this.isActive,
      this.pronoun,
      this.categories,
      this.isAlive,
      this.isPlayer,
      this.nameIsProperNoun,
      this.initiative})
      : super._() {
    if (id == null) throw new ArgumentError('null id');
    if (name == null) throw new ArgumentError('null name');
    if (team == null) throw new ArgumentError('null team');
    if (items == null) throw new ArgumentError('null items');
    if (health == null) throw new ArgumentError('null health');
    if (alreadyMentioned == null)
      throw new ArgumentError('null alreadyMentioned');
    if (isActive == null) throw new ArgumentError('null isActive');
    if (pronoun == null) throw new ArgumentError('null pronoun');
    if (categories == null) throw new ArgumentError('null categories');
    if (isAlive == null) throw new ArgumentError('null isAlive');
    if (isPlayer == null) throw new ArgumentError('null isPlayer');
    if (nameIsProperNoun == null)
      throw new ArgumentError('null nameIsProperNoun');
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
        alreadyMentioned == other.alreadyMentioned &&
        isActive == other.isActive &&
        pronoun == other.pronoun &&
        categories == other.categories &&
        isAlive == other.isAlive &&
        isPlayer == other.isPlayer &&
        nameIsProperNoun == other.nameIsProperNoun &&
        initiative == other.initiative;
  }

  int get hashCode {
    return hashObjects([
      id,
      name,
      team,
      items,
      currentWeapon,
      health,
      alreadyMentioned,
      isActive,
      pronoun,
      categories,
      isAlive,
      isPlayer,
      nameIsProperNoun,
      initiative
    ]);
  }

  String toString() {
    return 'Actor {'
        'id=${id.toString()}\n'
        'name=${name.toString()}\n'
        'team=${team.toString()}\n'
        'items=${items.toString()}\n'
        'currentWeapon=${currentWeapon.toString()}\n'
        'health=${health.toString()}\n'
        'alreadyMentioned=${alreadyMentioned.toString()}\n'
        'isActive=${isActive.toString()}\n'
        'pronoun=${pronoun.toString()}\n'
        'categories=${categories.toString()}\n'
        'isAlive=${isAlive.toString()}\n'
        'isPlayer=${isPlayer.toString()}\n'
        'nameIsProperNoun=${nameIsProperNoun.toString()}\n'
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
    super.alreadyMentioned = other.alreadyMentioned;
    super.isActive = other.isActive;
    super.pronoun = other.pronoun;
    super.categories = other.categories;
    super.isAlive = other.isAlive;
    super.isPlayer = other.isPlayer;
    super.nameIsProperNoun = other.nameIsProperNoun;
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
    if (alreadyMentioned == null)
      throw new ArgumentError('null alreadyMentioned');
    if (isActive == null) throw new ArgumentError('null isActive');
    if (pronoun == null) throw new ArgumentError('null pronoun');
    if (categories == null) throw new ArgumentError('null categories');
    if (isAlive == null) throw new ArgumentError('null isAlive');
    if (isPlayer == null) throw new ArgumentError('null isPlayer');
    if (nameIsProperNoun == null)
      throw new ArgumentError('null nameIsProperNoun');
    if (initiative == null) throw new ArgumentError('null initiative');
    return new _$Actor._(
        id: id,
        name: name,
        team: team,
        items: items,
        currentWeapon: currentWeapon,
        health: health,
        alreadyMentioned: alreadyMentioned,
        isActive: isActive,
        pronoun: pronoun,
        categories: categories,
        isAlive: isAlive,
        isPlayer: isPlayer,
        nameIsProperNoun: nameIsProperNoun,
        initiative: initiative);
  }
}
