import 'package:flutter/foundation.dart';

class AuthStateNotifier extends ChangeNotifier {
  bool _loggedIn = false;

  bool get isLoggedIn => _loggedIn;

  void update(bool value) {
    if (value == isLoggedIn) return;
    _loggedIn = value;
    notifyListeners();
  }
}
