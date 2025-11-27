import 'package:flutter/material.dart';
import 'src/application.dart';
import 'src/config/get_it/get_it.dart';
import 'src/config/router/app_router.dart';
import 'src/data/services/auth_state_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  final appRouter = AppRouter(getIt<AuthStateNotifier>());
  runApp(Application(appRouter));
}
