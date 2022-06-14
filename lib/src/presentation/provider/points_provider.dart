import 'package:flutter/material.dart';

import '../../database/persistence.dart';

class PointsProvider extends ChangeNotifier {
  Persistence persistenceBox = Persistence();
  int _points = 0;

  void setPoints(int pts) {
    _points = pts;
    persistenceBox.addData("points", _points);
    notifyListeners();
  }

  int getPoints() {
    _points = persistenceBox.getData("points", 0);
    return _points;
  }
}
