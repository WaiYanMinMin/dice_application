import 'package:flutter/material.dart';

import '../../database/persistence.dart';

class SoundProvider extends ChangeNotifier {
  Persistence persistenceBox = Persistence();
  bool _muted = false;
  void setMuted(bool muted) {
    _muted = muted;
    persistenceBox.addData("isMuted", _muted);
    notifyListeners();
  }

  bool getMuted() {
    _muted = persistenceBox.getData("isMuted", false);
    return _muted;
  }
}
