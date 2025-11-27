import 'package:flutter/foundation.dart';

import '../../../domain/services/auth_service.dart';

part 'login_state.dart';

class LoginNotifier extends ChangeNotifier {
  LoginNotifier(this._authService);

  final AuthService _authService;
  LoginState state = LoginState.initial();

  Future<void> login({required String email, required String password}) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      await _authService.login(email: email, password: password);
    } catch (e, s) {
      if (kDebugMode) {
        print('Exception: $e');
        print('StackTrace: $s');
      }
    } finally {
      state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }
}
