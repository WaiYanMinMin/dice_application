import 'package:flutter/material.dart';

import '../../database/persistence.dart';

class ThemeProvider extends ChangeNotifier {
  Persistence persistenceBox = Persistence();
  Color _themecolor = const Color(0xffDFE310);
  String _checkColor = "Yellow";
  bool _isSelected = true;
  String _bgImg = "assets/images/BGyellow.png";
  List<int> _ownedThemeList = [0];
  int _onTapIndex = 0;
  void setOntapIndex(int value) {
    _onTapIndex = value;
    persistenceBox.addData("onTapIndex", _onTapIndex);
    notifyListeners();
  }

  int getOntapIndex() {
    _onTapIndex = persistenceBox.getData("onTapIndex", 0);
    return _onTapIndex;
  }

  void addOwnedTheme(int index) {
    _ownedThemeList.add(index);
    persistenceBox.addData("ownedTheme", _ownedThemeList);
    notifyListeners();
  }

  List<int> getOwnedThemeList() {
    _ownedThemeList = persistenceBox.getData("ownedTheme", _ownedThemeList);
    return _ownedThemeList;
  }

  void setBG(String path) {
    _bgImg = path;
    persistenceBox.addData("bgImg", _bgImg);
    notifyListeners();
  }

  void setThemecolor(Color color, String checkColor) {
    _themecolor = color;
    _checkColor = checkColor;
    persistenceBox.addData(
      "changeTheme",
      _themecolor.toString().split('(0x')[1].split(')')[0],
    );
    persistenceBox.addData("checkColor", _checkColor);
    notifyListeners();
  }

  void selectedCheck() {
    _isSelected = true;
    persistenceBox.addData("isSelected", _isSelected);
    notifyListeners();
  }

  String getImgpath() {
    _bgImg = persistenceBox.getData("bgImg", _bgImg);
    return _bgImg;
  }

  bool getCheck() {
    _isSelected = persistenceBox.getData("isSelected", _isSelected);
    return _isSelected;
  }

  Color getThemecolor() {
    int colorcode = int.parse(
        (persistenceBox.getData(
          "changeTheme",
          _themecolor.toString().split('(0x')[1].split(')')[0],
        )),
        radix: 16);
    _themecolor = Color(colorcode);
    return _themecolor;
  }

  String getColor() {
    _checkColor = persistenceBox.getData("checkColor", _checkColor);
    return _checkColor;
  }
}
