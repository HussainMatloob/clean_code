import 'package:flutter/material.dart';

class AuthStateNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
  bool _accessDenied = false;

  bool get accessDenied => _accessDenied;

  void denyAccess() {
    _accessDenied = true;
    notifyListeners();
  }

  void clearAccessDenied() {
    _accessDenied = false;
    notifyListeners();
  }
}
