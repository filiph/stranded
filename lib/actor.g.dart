// GENERATED CODE - DO NOT MODIFY BY HAND

part of stranded.actor;

// **************************************************************************
// Generator: BuiltValueGenerator
// Target: abstract class Actor
// **************************************************************************

class _$Actor extends Actor {
  final bool alreadyMentioned;
  final List<String> categories;
  final Item currentWeapon;
  final Item shield;
  final Pose pose;
  final int id;
  final int initiative;
  final bool isActive;
  final bool isAlive;
  final bool isPlayer;
  final Set<Item> items;
  final String name;
  final bool nameIsProperNoun;
  final Pronoun pronoun;
  final Team team;
  _$Actor._(
      {this.alreadyMentioned,
      this.categories,
      this.currentWeapon,
      this.shield,
      this.pose,
      this.id,
      this.initiative,
      this.isActive,
      this.isAlive,
      this.isPlayer,
      this.items,
      this.name,
      this.nameIsProperNoun,
      this.pronoun,
      this.team})
      : super._() {
    if (alreadyMentioned == null)
      throw new ArgumentError('null alreadyMentioned');
    if (categories == null) throw new ArgumentError('null categories');
    if (pose == null) throw new ArgumentError('null pose');
    if (id == null) throw new ArgumentError('null id');
    if (initiative == null) throw new ArgumentError('null initiative');
    if (isActive == null) throw new ArgumentError('null isActive');
    if (isAlive == null) throw new ArgumentError('null isAlive');
    if (isPlayer == null) throw new ArgumentError('null isPlayer');
    if (items == null) throw new ArgumentError('null items');
    if (name == null) throw new ArgumentError('null name');
    if (nameIsProperNoun == null)
      throw new ArgumentError('null nameIsProperNoun');
    if (pronoun == null) throw new ArgumentError('null pronoun');
    if (team == null) throw new ArgumentError('null team');
  }
  factory _$Actor([updates(ActorBuilder b)]) =>
      (new ActorBuilder()..update(updates)).build();
  Actor rebuild(updates(ActorBuilder b)) =>
      (toBuilder()..update(updates)).build();
  _$ActorBuilder toBuilder() => new _$ActorBuilder()..replace(this);
  bool operator ==(other) {
    if (other is! Actor) return false;
    return alreadyMentioned == other.alreadyMentioned &&
        categories == other.categories &&
        currentWeapon == other.currentWeapon &&
        shield == other.shield &&
        pose == other.pose &&
        id == other.id &&
        initiative == other.initiative &&
        isActive == other.isActive &&
        isAlive == other.isAlive &&
        isPlayer == other.isPlayer &&
        items == other.items &&
        name == other.name &&
        nameIsProperNoun == other.nameIsProperNoun &&
        pronoun == other.pronoun &&
        team == other.team;
  }

  int get hashCode {
    return hashObjects([
      alreadyMentioned,
      categories,
      currentWeapon,
      shield,
      pose,
      id,
      initiative,
      isActive,
      isAlive,
      isPlayer,
      items,
      name,
      nameIsProperNoun,
      pronoun,
      team
    ]);
  }

  String toString() {
    return 'Actor {'
        'alreadyMentioned=${alreadyMentioned.toString()}\n'
        'categories=${categories.toString()}\n'
        'currentWeapon=${currentWeapon.toString()}\n'
        'shield=${shield.toString()}\n'
        'pose=${pose.toString()}\n'
        'id=${id.toString()}\n'
        'initiative=${initiative.toString()}\n'
        'isActive=${isActive.toString()}\n'
        'isAlive=${isAlive.toString()}\n'
        'isPlayer=${isPlayer.toString()}\n'
        'items=${items.toString()}\n'
        'name=${name.toString()}\n'
        'nameIsProperNoun=${nameIsProperNoun.toString()}\n'
        'pronoun=${pronoun.toString()}\n'
        'team=${team.toString()}\n'
        '}';
  }
}

class _$ActorBuilder extends ActorBuilder {
  _$ActorBuilder() : super._();
  void replace(Actor other) {
    super.alreadyMentioned = other.alreadyMentioned;
    super.categories = other.categories;
    super.currentWeapon = other.currentWeapon;
    super.shield = other.shield;
    super.pose = other.pose;
    super.id = other.id;
    super.initiative = other.initiative;
    super.isActive = other.isActive;
    super.isAlive = other.isAlive;
    super.isPlayer = other.isPlayer;
    super.items = other.items;
    super.name = other.name;
    super.nameIsProperNoun = other.nameIsProperNoun;
    super.pronoun = other.pronoun;
    super.team = other.team;
  }

  void update(updates(ActorBuilder b)) {
    if (updates != null) updates(this);
  }

  Actor build() {
    if (alreadyMentioned == null)
      throw new ArgumentError('null alreadyMentioned');
    if (categories == null) throw new ArgumentError('null categories');
    if (pose == null) throw new ArgumentError('null pose');
    if (id == null) throw new ArgumentError('null id');
    if (initiative == null) throw new ArgumentError('null initiative');
    if (isActive == null) throw new ArgumentError('null isActive');
    if (isAlive == null) throw new ArgumentError('null isAlive');
    if (isPlayer == null) throw new ArgumentError('null isPlayer');
    if (items == null) throw new ArgumentError('null items');
    if (name == null) throw new ArgumentError('null name');
    if (nameIsProperNoun == null)
      throw new ArgumentError('null nameIsProperNoun');
    if (pronoun == null) throw new ArgumentError('null pronoun');
    if (team == null) throw new ArgumentError('null team');
    return new _$Actor._(
        alreadyMentioned: alreadyMentioned,
        categories: categories,
        currentWeapon: currentWeapon,
        shield: shield,
        pose: pose,
        id: id,
        initiative: initiative,
        isActive: isActive,
        isAlive: isAlive,
        isPlayer: isPlayer,
        items: items,
        name: name,
        nameIsProperNoun: nameIsProperNoun,
        pronoun: pronoun,
        team: team);
  }
}
