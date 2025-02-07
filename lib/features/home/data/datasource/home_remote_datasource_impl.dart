import 'package:esab/features/home/data/datasource/home_remote_datasource.dart';
import 'package:esab/shared/util/app_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  HomeRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<bool> logout() async {
    try {
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      print('Logout error: $e');
      throw AppException(
        'Failed to log out from remote data source',
        message: e.toString(),
        statusCode: 500,
      );
    }
  }
}
