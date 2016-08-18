library stranded.team;

class Team {
  final int id;
  const Team(this.id);

  int get hashCode => id;

  bool operator ==(other) => other is Team && id == other.id;

  /// Currently, every team is enemy of every other team. In the future,
  /// we can implement allegiances etc.
  bool isEnemyWith(Team other) => id != other.id;
}

const Team playerTeam = const Team(0);
const Team defaultEnemyTeam = const Team(1);
