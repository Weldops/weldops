import 'package:dartz/dartz.dart';
import 'package:esab/features/auth/domain/repositories/auth_repository.dart';
import 'package:esab/shared/util/app_exception.dart';

class ResendEmailUseCase {
  final AuthRepository authRepository;

  ResendEmailUseCase({required this.authRepository});

  Future<Either<AppException, bool>> execute({required String email}) {
    return authRepository.resendEmail(email: email);
  }
}
