import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  const AuthFailure([String? message]) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String? message]) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure([String? message]) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String? message]) : super(message);
}
