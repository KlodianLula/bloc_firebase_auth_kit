import 'package:bloc_firebase_auth_kit/bloc_firebase_auth_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class AppServiceLocator {
  static Future<void> init() async {
    // Initialize auth package dependencies
    // For web with Google Sign-In, pass your client ID:
    await AuthServiceLocator.init(
      googleClientId: kIsWeb ? null : null, // TODO: Add your web client ID here
    );

    // Register the AuthBloc using the auth package's sl instance
    // Since both are using GetIt.instance, we can access them directly
    if (!getIt.isRegistered<AuthBloc>()) {
      getIt.registerFactory<AuthBloc>(() => AuthBloc(
            signInWithEmail: sl.get<SignInWithEmail>(),
            signInWithGoogle: sl.get<SignInWithGoogle>(),
            signInWithFacebook: sl.get<SignInWithFacebook>(),
            signOut: sl.get<SignOut>(),
            getCurrentUser: sl.get<GetCurrentUser>(),
            authRepository: sl.get<AuthRepository>(),
          ));
    }

    // Add any other app-specific dependencies here
    _initAppServices();
  }

  static void _initAppServices() {
    // Register app-specific services here
    // For example: API clients, other repositories, etc.
  }

  static Future<void> reset() async {
    await getIt.reset();
    await AuthServiceLocator.reset();
  }
}
