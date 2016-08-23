import 'package:stranded/storyline/storyline.dart';

/**
 * LoopedEvent is any event that gets executed in a loop, waiting for
 * a) resolution and b) need of player input. It is intended for 'minigames'
 * inside the egamebook.
 *
 * Example: a hand-to-hand combat can be a LoopedEvent that takes fighters
 * and loops through 'rounds' (seconds?) of the fight.
 */

abstract class LoopedEvent /*TODO: implements Saveable ?*/ {
  LoopedEvent(this._echo, this._goto, this._choices, this._choiceFunction) {
  }

  final StringTakingVoidFunction _goto;
  final StringTakingVoidFunction _echo;
  final ChoiceFunction _choiceFunction;
  final dynamic _choices;

  bool finished = false;

  /// The page to jump to when combat is finished.
  String onFinishedGoto;

  void update(Storyline storyline, ChoiceFunction _choiceFunction);

  /**
   * Runs the update loop until user interaction is needed or until LoopedEvent
   * is finished.
   */
  void run() {
    if (onFinishedGoto == null) throw new StateError("Cannot run a LoopedEvent "
        "before onFinishedGoto is defined.");
    if (finished) {
      _choices.clear();
      _goto(onFinishedGoto);
      return;
    }

    var storyline = new Storyline();
    while (!finished && _choices.isEmpty) {
      update(storyline, this._choiceFunction);
    }
    _echo(storyline.toString());
  }
}

typedef void StringTakingVoidFunction(String arg);

/// Mock of the signature of `choice()` in EgbScripter.
typedef dynamic ChoiceFunction(String string, {void script()});