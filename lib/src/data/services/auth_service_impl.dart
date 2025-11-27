import 'dart:async';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/token/token_storage_service.dart';
import 'auth_state_notifier.dart';

class AuthServiceImpl implements AuthService {
  AuthServiceImpl({
    required TokenStorageService tokenStorageService,
    required AuthRepository authRepository,
    required AuthStateNotifier authStateNotifier,
  }) : _tokenStorageService = tokenStorageService,
       _authRepository = authRepository,
       _authStateNotifier = authStateNotifier {
    _init();
  }

  final TokenStorageService _tokenStorageService;
  final AuthRepository _authRepository;
  final AuthStateNotifier _authStateNotifier;

  Future<void> _init() async {
    final isLoggedIn = await _tokenStorageService.getToken() != null;
    _authStateNotifier.update(isLoggedIn);
  }

  @override
  Future<void> login({required String email, required String password}) async {
    final token = await _authRepository.login(email: email, password: password);
    await _tokenStorageService.saveToken(token);
    _authStateNotifier.update(true);
  }

  @override
  Future<void> logout() async {
    await _authRepository.logout();
    await _tokenStorageService.clearToken();
    _authStateNotifier.update(false);
  }
}
