import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/token/token_storage_service.dart';

class SharedPrefsTokenStorage implements TokenStorageService {
  SharedPrefsTokenStorage(this._prefs);

  static const _tokenKey = 'auth_token';

  final SharedPreferences _prefs;

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() {
    return Future.value(_prefs.getString(_tokenKey));
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }
}
