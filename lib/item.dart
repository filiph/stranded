library stranded.item;

import 'dart:math';

import 'package:stranded/actor.dart';

enum ItemType { SPEAR, BRANCH, TENT }

String typeToDescription(ItemType type) {
  switch (type) {
    case ItemType.SPEAR:
      return "spear";
    case ItemType.BRANCH:
      return "branch";
    case ItemType.TENT:
      return "tent";
  }
}

Random _random = new Random();

abstract class Item {
  final ItemType type;
  final String description;

  int _hash;

  Item(ItemType type, {int hashCode})
      : type = type,
        description = typeToDescription(type) {
    _hash = hashCode ?? _random.nextInt(0xffffffff);
  }

  factory Item.duplicate(Item other) => other.copy(identical: true);

  /// Makes a copy of instance. To be overridden by subclasses.
  ///
  /// When [identical] is `true`, the returned copy should have the same
  /// hashCode as this instance.
  Item copy({bool identical: false});

  @override
  int get hashCode => _hash;

  /// When `true`, having more of [this] makes the person happier.
  ///
  /// For example, having more of coins makes an [Actor] happier. On the other
  /// hand, having just one tent is enough -- it won't make the person
  /// happier to have 2 tents.
  bool get luxuryIsCumulative;

  /// This is the intrinsic value of the item.
  ///
  /// When [luxuryScore] is high, people (AI) will be more incentivized to
  /// get it. Sleeping in a tent (as opposed to 'below a tree branch') is
  /// a massive luxury improvement.
  ///
  /// Note that the way AI plans, items don't need to have their own (intrinsic)
  /// value to be wanted. Branch in itself doesn't help you, but it does get
  /// you to traps, which get you to food.
  num get luxuryScore;

  bool operator ==(o) => o is Item && hashCode == o.hashCode;

  /// Creates [value] number of copies (that's including this instance).
  Iterable<Item> operator *(int value) {
    var list = new List<Item>.generate(value - 1, (i) => copy());
    list.insert(0, this);
    return list;
  }
}

class Branch extends Item {
  Branch({int hashCode}) : super(ItemType.BRANCH, hashCode: hashCode);

  Branch copy({bool identical: false}) =>
      new Branch(hashCode: identical ? hashCode : null);

  bool luxuryIsCumulative = false;
  num luxuryScore = 0;
}

class Tent extends Item {
  Tent({int hashCode}) : super(ItemType.TENT, hashCode: hashCode);

  Tent copy({bool identical: false}) =>
      new Tent(hashCode: identical ? hashCode : null);

  bool luxuryIsCumulative = false;
  num luxuryScore = 10;
}

// trap
// set of clothes
