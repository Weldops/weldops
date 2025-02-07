import 'package:dartz/dartz.dart';
import 'package:esab/models/response/response.dart';

class AppException implements Exception {
  final String? message;
  final int? statusCode;

  AppException(
    String s, {
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'AppException{message: $message, statusCode: $statusCode}';
  }
}

extension HttpExceptionExtension on AppException {
  Left<AppException, Response> get toLeft => Left<AppException, Response>(this);
}
