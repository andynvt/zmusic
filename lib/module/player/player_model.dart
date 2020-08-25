import 'package:flutter/material.dart';

import 'player_logic.dart';

class PlayerModel extends ChangeNotifier {
  PlayerLogic _logic;
  PlayerLogic get logic => _logic;

  PlayerModel() {
    _logic = PlayerLogic(this);
  }
}
