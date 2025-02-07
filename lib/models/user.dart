import 'package:firebase_auth/firebase_auth.dart' as fb;

class User {
  final String uid;
  final String? email;
  final bool isEmailVerified;

  User({
    required this.uid,
    this.email,
    this.isEmailVerified = false,
  });

  factory User.fromFirebaseUser(fb.User firebaseUser) {
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      isEmailVerified: firebaseUser.emailVerified,
    );
  }
}
