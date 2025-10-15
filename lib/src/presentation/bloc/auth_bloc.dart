import 'dart:async';

import 'package:bloc_firebase_auth_kit/bloc_firebase_auth_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.signInWithEmail,
    required this.signInWithGoogle,
    required this.signInWithFacebook,
    required this.signOut,
    required this.getCurrentUser,
    required this.authRepository,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<AuthSignUpWithEmailRequested>(_onSignUpWithEmailRequested);
    on<AuthSignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<AuthSignInWithFacebookRequested>(_onSignInWithFacebookRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthProfileUpdateRequested>(_onProfileUpdateRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthEmailVerificationRequested>(_onEmailVerificationRequested);
    on<AuthDeleteAccountRequested>(_onDeleteAccountRequested);
  }

  final SignInWithEmail signInWithEmail;
  final SignInWithGoogle signInWithGoogle;
  final SignInWithFacebook signInWithFacebook;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final AuthRepository authRepository;

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user: user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignInWithEmailRequested(
    AuthSignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signInWithEmail(event.email, event.password);

    result.fold(
      (failure) => emit(AuthError(message: failure.message ?? 'Sign in failed')),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignUpWithEmailRequested(
    AuthSignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.signUpWithEmailAndPassword(
      event.email,
      event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message ?? 'Sign up failed')),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignInWithGoogleRequested(
    AuthSignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signInWithGoogle();

    result.fold(
      (failure) => emit(AuthError(message: failure.message ?? 'Google sign in failed')),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignInWithFacebookRequested(
    AuthSignInWithFacebookRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signInWithFacebook();

    result.fold(
      (failure) => emit(AuthError(message: failure.message ?? 'Facebook sign in failed')),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signOut();

    result.fold(
      (failure) => emit(AuthError(message: failure.message ?? 'Sign out failed')),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onProfileUpdateRequested(
    AuthProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.updateProfile(
      displayName: event.displayName,
      photoURL: event.photoURL,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message ?? 'Profile update failed')),
      (user) => emit(AuthProfileUpdated(user: user)),
    );
  }

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.sendPasswordResetEmail(event.email);

    result.fold(
      (failure) => emit(AuthError(message: failure.message ?? 'Password reset failed')),
      (_) => emit(const AuthPasswordResetEmailSent()),
    );
  }

  Future<void> _onEmailVerificationRequested(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.sendEmailVerification();

    result.fold(
      (failure) => emit(AuthError(message: failure.message ?? 'Email verification failed')),
      (_) => emit(const AuthEmailVerificationSent()),
    );
  }

  Future<void> _onDeleteAccountRequested(
    AuthDeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.deleteAccount();

    result.fold(
      (failure) => emit(AuthError(message: failure.message ?? 'Account deletion failed')),
      (_) => emit(const AuthAccountDeleted()),
    );
  }
}
