import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmail {
  const SignInWithEmail(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.signInWithEmailAndPassword(email, password);
  }
}
