import 'package:esab/models/user.dart';

abstract class AuthRemoteDataSource {
  Future<User?> signIn(String email, String password);

  Future<User?> createAccount(String email, String password);

  Future<User?> signInWithGoogle();

  Future<bool> resendEmail(String email);
}
