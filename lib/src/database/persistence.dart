import 'package:hive_flutter/adapters.dart';

class Persistence {
  final _mybox = Hive.box("persistence_box");

  void setFirstRun(bool isFirstRun) {
    _mybox.put("isFirstRun", isFirstRun);
  }

  bool checkFirstRun() {
    if (_mybox.get("isFirstRun") == null) {
      _mybox.put("isFirstRun", true);
    }
    return _mybox.get("isFirstRun");
  }

  void addData(String key, dynamic value) {
    _mybox.put(key, value);
  }

  getData(String key, dynamic defaultvalue) {
    return _mybox.get(key, defaultValue: defaultvalue);
  }

  void deleteData(String key) {
    _mybox.delete(key);
  }
}
