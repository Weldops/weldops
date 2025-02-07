import 'package:dartz/dartz.dart';
import 'package:esab/features/auth/domain/repositories/auth_repository.dart';
import 'package:esab/models/user.dart';
import 'package:esab/shared/util/app_exception.dart';

class GoogleSignInUseCase {
  final AuthRepository authRepository;

  GoogleSignInUseCase({required this.authRepository});

  Future<Either<AppException, User>> execute() {
    return authRepository.signInWithGoogle();
  }
}
