import '../api/api_client.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    // final result = await _apiClient.post('/login', {
    //   'email': email,
    //   'password': password,
    // });
    return Future.delayed(const Duration(milliseconds: 600), () => 'TOKEN IS');
  }

  @override
  Future<void> logout() async {
    // await _apiClient.post('/logout', {});
    return Future.delayed(const Duration(milliseconds: 200), () {});
  }
}
