import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({
    super.key,
    required this.authenticatedBuilder,
    required this.unauthenticatedBuilder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  final Widget Function(BuildContext context) authenticatedBuilder;
  final Widget Function(BuildContext context) unauthenticatedBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, String message)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return loadingBuilder?.call(context) ?? const _DefaultLoadingWidget();
        } else if (state is AuthAuthenticated || state is AuthProfileUpdated) {
          return authenticatedBuilder(context);
        } else if (state is AuthError) {
          return errorBuilder?.call(context, state.message) ?? _DefaultErrorWidget(message: state.message);
        } else {
          // AuthUnauthenticated, AuthPasswordResetEmailSent, AuthEmailVerificationSent, AuthAccountDeleted
          return unauthenticatedBuilder(context);
        }
      },
    );
  }
}

class _DefaultLoadingWidget extends StatelessWidget {
  const _DefaultLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  const _DefaultErrorWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // You can add retry logic here
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
