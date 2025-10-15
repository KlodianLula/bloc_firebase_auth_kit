import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/user_entity.dart' as domain;

class UserModel extends domain.UserEntity {
  const UserModel({
    required super.uid,
    super.email,
    super.displayName,
    super.photoURL,
    super.phoneNumber,
    super.isEmailVerified = false,
    super.providerData = const [],
    super.metadata,
  });

  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
      isEmailVerified: user.emailVerified,
      providerData: user.providerData.map((e) => e.providerId).toList(),
      metadata: UserMetadataModel.fromFirebaseMetadata(user.metadata),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      phoneNumber: json['phoneNumber'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      providerData: List<String>.from(json['providerData'] ?? []),
      metadata: json['metadata'] != null ? UserMetadataModel.fromJson(json['metadata']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
      'providerData': providerData,
      'metadata': metadata != null ? (metadata as UserMetadataModel).toJson() : null,
    };
  }
}

class UserMetadataModel extends domain.UserMetadata {
  const UserMetadataModel({
    required DateTime? creationTime,
    required DateTime? lastSignInTime,
  }) : super(
          creationTime: creationTime,
          lastSignInTime: lastSignInTime,
        );

  factory UserMetadataModel.fromFirebaseMetadata(firebase_auth.UserMetadata metadata) {
    return UserMetadataModel(
      creationTime: metadata.creationTime,
      lastSignInTime: metadata.lastSignInTime,
    );
  }

  factory UserMetadataModel.fromJson(Map<String, dynamic> json) {
    return UserMetadataModel(
      creationTime: json['creationTime'] != null ? DateTime.parse(json['creationTime']) : null,
      lastSignInTime: json['lastSignInTime'] != null ? DateTime.parse(json['lastSignInTime']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creationTime': creationTime?.toIso8601String(),
      'lastSignInTime': lastSignInTime?.toIso8601String(),
    };
  }
}
