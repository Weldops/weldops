import 'package:dartz/dartz.dart';
import 'package:esab/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:esab/features/auth/domain/repositories/auth_repository.dart';
import 'package:esab/models/user.dart';
import 'package:esab/shared/util/app_exception.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<AppException, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authRemoteDataSource.signIn(email, password);

      if (user == null) {
        return Left(AppException(
          'Failed to sign in: User not found',
          message: 'Failed to Sign In',
          statusCode: 0,
        ));
      }
      return Right(user);
    } catch (e) {
      return Left(AppException('Failed to sign in: $e',
          message: e.toString(), statusCode: 0));
    }
  }

  @override
  Future<Either<AppException, User>> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      // Call the remote data source to create an account.
      final user = await authRemoteDataSource.createAccount(email, password);

      // If the user is null, return an error indicating failure.
      if (user == null) {
        return Left(AppException(
          'Failed to create account: User creation returned null',
          message: 'Failed to create account',
          statusCode: 400, // Use a more appropriate status code
        ));
      }

      // If user creation was successful, return the created user.
      return Right(user);
    } catch (e) {
      // Catch any errors and wrap them in an AppException.
      return Left(AppException(
        'Failed to create account: $e',
        message: e.toString(),
        statusCode: 500, // Internal server error, adjust as needed
      ));
    }
  }

  @override
  Future<Either<AppException, User>> signInWithGoogle() async {
    try {
      final user = await authRemoteDataSource.signInWithGoogle();

      if (user == null) {
        return Left(AppException(
          'Google Sign-In failed: User not found',
          message: 'Failed to authenticate using Google. Please try again.',
          statusCode: 401,
        ));
      }
      return Right(user);
    } catch (e) {
      return Left(AppException(
        'Google Sign-In failed: $e',
        message: e.toString(),
        statusCode: 500,
      ));
    }
  }

  @override
  Future<Either<AppException, bool>> resendEmail(
      {required String email}) async {
    try {
      final success = await authRemoteDataSource.resendEmail(email);

      if (!success) {
        return Left(AppException(
          'Failed to resend email verification.',
          message: 'Unable to resend the email. Please try again later.',
          statusCode: 400,
        ));
      }

      return Right(success);
    } catch (e) {
      return Left(AppException(
        'Resend email failed: $e',
        message: e.toString(),
        statusCode: 500,
      ));
    }
  }
}
