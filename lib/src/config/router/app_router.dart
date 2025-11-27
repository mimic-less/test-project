import 'package:go_router/go_router.dart';

import '../../data/services/auth_state_notifier.dart';
import '../../domain/models/photo.dart';
import '../../presentation/gallery_page/gallery_screen.dart';
import '../../presentation/login_page/login_screen.dart';
import '../../presentation/photo_preview_page/photo_preview_screen.dart';

class AppRouter {
  AppRouter(this._authState) {
    _router = _build();
  }

  final AuthStateNotifier _authState;

  late final GoRouter _router;

  GoRouter get router => _router;

  GoRouter _build() {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: _authState,
      redirect: (_, state) {
        final loggedIn = _authState.isLoggedIn;
        final loggingIn = state.matchedLocation == '/login-screen';

        if (!loggedIn && !loggingIn) return '/login-screen';
        if (loggedIn && loggingIn) return '/';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login-screen',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(path: '/', builder: (context, state) => const GalleryScreen()),
        GoRoute(
          path: '/gallery-screen/image-preview-screen',
          builder: (context, state) {
            final query = state.extra as Photo;
            return PhotoPreviewScreen(photo: query);
          },
        ),
      ],
    );
  }
}
