import 'package:flutter/material.dart';

import 'detail_logic.dart';

class DetailModel extends ChangeNotifier {
  DetailLogic _logic;
  DetailLogic get logic => _logic;

  DetailModel() {
    _logic = DetailLogic(this);
  }
}
