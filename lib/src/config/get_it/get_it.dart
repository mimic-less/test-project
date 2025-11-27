import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/services/auth_service.dart';
import '../../data/services/auth_service_impl.dart';
import '../../data/services/auth_state_notifier.dart';
import '../../data/token/shared_prefs_token_storage.dart';
import '../../domain/token/token_storage_service.dart';
import '../../data/repositories/gallery_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/gallery_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  final tokenStorage = SharedPrefsTokenStorage(prefs);

  final dio = Dio();

  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  );
  final authStateNotifier = AuthStateNotifier();
  final authRepository = AuthRepositoryImpl(dio);
  final authService = AuthServiceImpl(
    tokenStorageService: tokenStorage,
    authRepository: authRepository,
    authStateNotifier: authStateNotifier,
  );

  final galleryRepository = GalleryRepositoryImpl(dio);

  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<TokenStorageService>(tokenStorage);

  getIt.registerSingleton<AuthStateNotifier>(authStateNotifier);
  getIt.registerSingleton<AuthRepository>(authRepository);
  getIt.registerSingleton<AuthService>(authService);

  getIt.registerSingleton<GalleryRepository>(galleryRepository);
}
