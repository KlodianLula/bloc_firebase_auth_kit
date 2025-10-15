import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({
    super.key,
    this.showGoogle = true,
    this.showFacebook = true,
    this.showApple = false,
  });

  final bool showGoogle;
  final bool showFacebook;
  final bool showApple;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showGoogle) ...[
              SignInButton(
                Buttons.Google,
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<AuthBloc>().add(const AuthSignInWithGoogleRequested());
                      },
                text: 'Sign in with Google',
              ),
              const SizedBox(height: 12),
            ],
            if (showFacebook) ...[
              SignInButton(
                Buttons.Facebook,
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<AuthBloc>().add(const AuthSignInWithFacebookRequested());
                      },
                text: 'Sign in with Facebook',
              ),
              const SizedBox(height: 12),
            ],
            if (showApple) ...[
              SignInButton(
                Buttons.Apple,
                onPressed: isLoading
                    ? null
                    : () {
                        // Apple sign in implementation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Apple Sign In coming soon!'),
                          ),
                        );
                      },
                text: 'Sign in with Apple',
              ),
            ],
          ],
        );
      },
    );
  }
}
