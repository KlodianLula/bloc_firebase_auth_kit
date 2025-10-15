import 'package:bloc_firebase_auth_kit/bloc_firebase_auth_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/app_service_locator.dart';
import 'core/routing/app_router.dart';
import 'firebase_options.dart';

/// Example app demonstrating bloc_firebase_auth_kit package usage
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize dependency injection
    await AppServiceLocator.init();

    runApp(const ExampleApp());
  } catch (e) {
    print('Error during app initialization: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Initialization Error: $e'),
        ),
      ),
    ));
  }
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<AuthBloc>()..add(const AuthCheckRequested()),
      child: MaterialApp.router(
        title: 'bloc_firebase_auth_kit Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
