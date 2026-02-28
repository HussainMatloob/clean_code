import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_project/core/exceptions/server_exceptions.dart';

class AppExceptions {
  static AppException handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException(
        "Your Internet is not stable",
        e.response?.statusCode,
      );
    }

    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final message =
          e.response?.data?['message']?.toString() ?? e.message ?? '';
      debugPrint("error message in exception class is : $message");
      debugPrint("error code in exception class is : $statusCode");
      switch (statusCode) {
        case 400:
        case 422:
          return BadRequestException(message, statusCode);
        case 401:
        case 403:
          return UnauthorizedException(message, statusCode);
        case 404:
          return NotFoundException(message, statusCode);
        case 500:
        case 502:
        case 503:
          return ServerException(message, statusCode);
        default:
          return UnknownException('Something went wrong', statusCode);
      }
    }

    return NetworkException('Internet is not stable');
  }
}
