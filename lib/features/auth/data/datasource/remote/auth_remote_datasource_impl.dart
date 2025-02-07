import 'package:esab/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:esab/models/user.dart' as custom;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final fb.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignInInstance;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignInInstance,
  });

  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  @override
  Future<custom.User?> signIn(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fb.User? firebaseUser = userCredential.user;

      // Convert Firebase user to custom User class if sign-in is successful
      if (firebaseUser != null) {
        return custom.User.fromFirebaseUser(firebaseUser);
      }
      return null;
    } on fb.FirebaseAuthException catch (e) {
      print('Firebase sign-in error: ${e.message} (code: ${e.code})');
      String errorMessage = _getErrorMessage(e);
      throw errorMessage;
    } catch (e) {
      print('Sign-in error: $e');
      throw 'Sign-in error: ${e.toString()}';
    }
  }

  @override
  Future<custom.User?> createAccount(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fb.User? firebaseUser = userCredential.user;

      if (firebaseUser != null && !firebaseUser.emailVerified) {
        await firebaseUser.sendEmailVerification();
        return custom.User.fromFirebaseUser(firebaseUser);
      }
      return null; // Account creation failed
    } on fb.FirebaseAuthException catch (e) {
      print('Firebase sign-up error: ${e.message} (code: ${e.code})');
      String errorMessage = _getErrorMessage(e);
      throw errorMessage;
    } catch (e) {
      print('Sign-up error: $e');
      throw 'Sign-up error: ${e.toString()}';
    }
  }

  Future<custom.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await googleSignInInstance.signIn(); // Updated field name
      if (googleUser == null) {
        throw 'Google Sign-In aborted';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final fb.OAuthCredential credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final fb.UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final fb.User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        return custom.User.fromFirebaseUser(firebaseUser);
      }
      return null;
    } on fb.FirebaseAuthException catch (e) {
      print('Google Sign-In error: ${e.message} (code: ${e.code})');
      String errorMessage = _getErrorMessage(e);
      throw errorMessage;
    } catch (e) {
      print('Google Sign-In error: $e');
      throw 'Google Sign-In error: ${e.toString()}';
    }
  }

  @override
  Future<bool> resendEmail(String email) async {
    try {
      final fb.User? user = firebaseAuth.currentUser;

      if (user == null || !user.emailVerified) {
        await user?.sendEmailVerification();
        return true;
      } else {
        throw 'User email is already verified or does not exist.';
      }
    } on fb.FirebaseAuthException catch (e) {
      print('Resend email error: ${e.message} (code: ${e.code})');
      throw _getErrorMessage(e);
    } catch (e) {
      print('Resend email unexpected error: $e');
      throw 'Resend email error: ${e.toString()}';
    }
  }

  String _getErrorMessage(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        return 'The credentials provided are invalid. Please check your email and password.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'The password you entered is incorrect.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
}
