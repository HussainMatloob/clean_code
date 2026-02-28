import 'package:test_project/core/exceptions/server_exceptions.dart';

class ResponseResult<T> {
  final T? data;
  final AppException? error;

  bool get isSuccess => error == null;

  ResponseResult.success(this.data) : error = null;
  ResponseResult.failure(this.error) : data = null;
}
