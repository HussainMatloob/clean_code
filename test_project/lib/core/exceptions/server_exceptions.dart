class AppException implements Exception {
  final String message;
  final int? code;

  AppException(this.message, [this.code]);
}

class NetworkException extends AppException {
  NetworkException([super.message = 'No Internet connection', super.code]);
}

class ServerException extends AppException {
  ServerException([super.message = 'Server error occurred', super.code]);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Unauthorized access', super.code]);
}

class BadRequestException extends AppException {
  BadRequestException([super.message = 'Bad request', super.code]);
}

class NotFoundException extends AppException {
  NotFoundException([super.message = 'Resource not found', super.code]);
}

class UnknownException extends AppException {
  UnknownException([super.message = 'Something went wrong', super.code]);
}

class LocalDatabaseException extends AppException {
  LocalDatabaseException([
    super.message = 'Could not load favorites',
    super.code,
  ]);
}
