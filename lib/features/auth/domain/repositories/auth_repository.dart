import 'package:dartz/dartz.dart';
import 'package:esab/models/user.dart';
import 'package:esab/shared/util/app_exception.dart';

abstract class AuthRepository {
  Future<Either<AppException, User>> signIn(
      {required String email, required String password});

  Future<Either<AppException, User>> createAccount(
      {required String email, required String password});

  Future<Either<AppException, User>> signInWithGoogle();

  Future<Either<AppException, bool>> resendEmail({required String email});
}
