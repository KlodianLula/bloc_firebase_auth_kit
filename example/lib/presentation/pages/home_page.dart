import 'package:bloc_firebase_auth_kit/bloc_firebase_auth_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go(AppRouter.profile),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back!',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hello, ${state.user.displayName ?? state.user.email ?? 'User'}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              if (state.user.photoURL != null)
                                CircleAvatar(
                                  backgroundImage: NetworkImage(state.user.photoURL!),
                                  radius: 30,
                                )
                              else
                                CircleAvatar(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  radius: 30,
                                  child: Text(
                                    (state.user.displayName?.isNotEmpty ?? false)
                                        ? state.user.displayName![0].toUpperCase()
                                        : (state.user.email?.isNotEmpty ?? false)
                                            ? state.user.email![0].toUpperCase()
                                            : 'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (state.user.email != null)
                                      Text(
                                        state.user.email!,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    if (state.user.phoneNumber != null)
                                      Text(
                                        state.user.phoneNumber!,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    Row(
                                      children: [
                                        Icon(
                                          state.user.isEmailVerified ? Icons.verified : Icons.warning,
                                          color: state.user.isEmailVerified ? Colors.green : Colors.orange,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.user.isEmailVerified ? 'Email verified' : 'Email not verified',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _QuickActionCard(
                          icon: Icons.person,
                          title: 'Profile',
                          subtitle: 'View and edit profile',
                          onTap: () => context.go(AppRouter.profile),
                        ),
                        if (!state.user.isEmailVerified)
                          _QuickActionCard(
                            icon: Icons.email,
                            title: 'Verify Email',
                            subtitle: 'Send verification email',
                            onTap: () {
                              context.read<AuthBloc>().add(
                                    const AuthEmailVerificationRequested(),
                                  );
                            },
                          ),
                        _QuickActionCard(
                          icon: Icons.settings,
                          title: 'Settings',
                          subtitle: 'App preferences',
                          onTap: () {
                            // Navigate to settings
                          },
                        ),
                        _QuickActionCard(
                          icon: Icons.info,
                          title: 'About',
                          subtitle: 'App information',
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: 'bloc_firebase_auth_kit Demo',
                              applicationVersion: '1.0.0',
                              children: const [
                                Text('A demo application showcasing the bloc_firebase_auth_kit package with Firebase Authentication and clean architecture.'),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
