import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/get_it/get_it.dart';
import 'config/router/app_router.dart';
import 'domain/services/auth_service.dart';

class Application extends StatelessWidget {
  const Application(this.appRouter, {super.key});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => getIt<AuthService>(),
      child: MaterialApp.router(
        routerConfig: appRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
