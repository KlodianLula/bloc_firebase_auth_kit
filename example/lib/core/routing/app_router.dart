import 'package:bloc_firebase_auth_kit/bloc_firebase_auth_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/auth_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/profile_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../di/app_service_locator.dart';

class AppRouter {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String profile = '/profile';

  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: splash,
    redirect: _redirect,
    refreshListenable: _AuthStateNotifier(),
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: auth,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );

  static String? _redirect(BuildContext context, GoRouterState state) {
    // Get the current user synchronously - this is safe because we're just checking cache
    final getCurrentUser = getIt.get<GetCurrentUser>();
    final user = getCurrentUser();

    final isOnSplashPage = state.matchedLocation == splash;
    final isOnAuthPage = state.matchedLocation == auth;

    // If user is authenticated
    if (user != null) {
      if (isOnSplashPage || isOnAuthPage) {
        return home;
      }
    } else {
      // User is not authenticated
      if (!isOnAuthPage && !isOnSplashPage) {
        return auth;
      }
    }

    return null; // No redirect needed
  }
}

class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier() {
    final getCurrentUser = getIt.get<GetCurrentUser>();
    getCurrentUser.authStateChanges.listen((_) {
      notifyListeners();
    });
  }
}
