import 'package:flutter/foundation.dart';

class NavModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setIndex(int i) {
    if (i == _selectedIndex) return;
    _selectedIndex = i;
    notifyListeners();
  }
}