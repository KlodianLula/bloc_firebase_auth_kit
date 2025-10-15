import 'package:equatable/equatable.dart';

/// Represents an authenticated user in the application.
///
/// This entity contains all the user information returned from Firebase Auth.
/// It is immutable and uses Equatable for value comparison.
class UserEntity extends Equatable {
  /// Creates a [UserEntity].
  ///
  /// The [uid] is required and uniquely identifies the user.
  /// Other properties are optional and depend on the authentication method used.
  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.isEmailVerified = false,
    this.providerData = const [],
    this.metadata,
  });

  /// The unique identifier for this user.
  final String uid;

  /// The user's email address, if available.
  final String? email;

  /// The user's display name, if available.
  final String? displayName;

  /// The user's profile photo URL, if available.
  final String? photoURL;

  /// The user's phone number, if available.
  final String? phoneNumber;

  /// Whether the user's email has been verified.
  final bool isEmailVerified;

  /// List of authentication provider IDs linked to this user.
  final List<String> providerData;

  /// Metadata about the user's account creation and sign-in times.
  final UserMetadata? metadata;

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoURL,
        phoneNumber,
        isEmailVerified,
        providerData,
        metadata,
      ];
}

/// Contains metadata about a user's account.
class UserMetadata extends Equatable {
  /// Creates [UserMetadata].
  const UserMetadata({
    this.creationTime,
    this.lastSignInTime,
  });

  /// The time when the user account was created.
  final DateTime? creationTime;

  /// The time when the user last signed in.
  final DateTime? lastSignInTime;

  @override
  List<Object?> get props => [creationTime, lastSignInTime];
}
