import 'package:dartz/dartz.dart';
import 'package:esab/features/auth/domain/repositories/auth_repository.dart';
import 'package:esab/models/user.dart';
import 'package:esab/shared/util/app_exception.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  Future<Either<AppException, User>> execute(
      {required String email, required String password}) {
    return authRepository.signIn(email: email, password: password);
  }
}
