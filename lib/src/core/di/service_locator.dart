import 'package:bloc_firebase_auth_kit/bloc_firebase_auth_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

/// Service locator for authentication dependencies.
///
/// Initialize this before using any auth features:
/// ```dart
/// await AuthServiceLocator.init(
///   googleClientId: kIsWeb ? 'YOUR_WEB_CLIENT_ID' : null,
/// );
/// ```
class AuthServiceLocator {
  /// Initializes all authentication dependencies.
  ///
  /// [googleClientId] - Optional Google OAuth client ID for web platform.
  /// For web apps, you must provide your web client ID here or add it as a meta tag in index.html.
  static Future<void> init({String? googleClientId}) async {
    await _initSharedPreferences();
    await _initDataSources(googleClientId: googleClientId);
    _initRepositories();
    _initUseCases();
    _initBlocs();
  }

  static Future<void> _initSharedPreferences() async {
    if (!sl.isRegistered<SharedPreferences>()) {
      final prefs = await SharedPreferences.getInstance();
      sl.registerLazySingleton<SharedPreferences>(() => prefs);
    }
  }

  static Future<void> _initDataSources({String? googleClientId}) async {
    // External dependencies
    if (!sl.isRegistered<FirebaseAuth>()) {
      sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    }

    // Configure GoogleSignIn with optional client ID for web
    if (!sl.isRegistered<GoogleSignIn>()) {
      sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(
            clientId: kIsWeb ? googleClientId : null,
          ));
    }

    // Data sources
    if (!sl.isRegistered<AuthLocalDataSource>()) {
      sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sl()),
      );
    }

    if (!sl.isRegistered<AuthRemoteDataSource>()) {
      sl.registerLazySingleton<AuthRemoteDataSource>(
        () => FirebaseAuthRemoteDataSource(sl(), sl()),
      );
    }
  }

  static void _initRepositories() {
    if (!sl.isRegistered<AuthRepository>()) {
      sl.registerLazySingleton<AuthRepository>(
        () => FirebaseAuthRepository(
          remoteDataSource: sl(),
          localDataSource: sl(),
        ),
      );
    }
  }

  static void _initUseCases() {
    if (!sl.isRegistered<SignInWithEmail>()) {
      sl.registerLazySingleton(() => SignInWithEmail(sl()));
    }
    if (!sl.isRegistered<SignInWithGoogle>()) {
      sl.registerLazySingleton(() => SignInWithGoogle(sl()));
    }
    if (!sl.isRegistered<SignInWithFacebook>()) {
      sl.registerLazySingleton(() => SignInWithFacebook(sl()));
    }
    if (!sl.isRegistered<SignOut>()) {
      sl.registerLazySingleton(() => SignOut(sl()));
    }
    if (!sl.isRegistered<GetCurrentUser>()) {
      sl.registerLazySingleton(() => GetCurrentUser(sl()));
    }
  }

  static void _initBlocs() {
    // Remove the automatic AuthBloc registration since we'll handle it in the main app
    // This prevents double registration issues
  }

  /// Resets all registered dependencies.
  /// Useful for testing or reinitializing with different configuration.
  static Future<void> reset() async {
    await sl.reset();
  }
}
