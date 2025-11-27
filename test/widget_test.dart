// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:plantin_test_project/src/config/get_it/get_it.dart';
import 'package:plantin_test_project/src/domain/token/token_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Testing TokenStorage', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await setupDependencies();
    });

    tearDown(() {
      GetIt.I.reset();
    });

    test('Storage is initialized', () {
      final tokenService = GetIt.I<TokenStorageService>();
      expect(tokenService, isNotNull);
    });

    test('Save/Get Token', () async {
      final tokenService = GetIt.I<TokenStorageService>();
      const testToken = 'my_test_token';

      await tokenService.saveToken(testToken);
      final token = await tokenService.getToken();

      expect(token, testToken);
    });

    test('Clean Token', () async {
      final tokenService = GetIt.I<TokenStorageService>();
      const testToken = 'my_test_token';

      await tokenService.saveToken(testToken);
      await tokenService.clearToken();
      final token = await tokenService.getToken();

      expect(token, isNull);
    });
  });
}
