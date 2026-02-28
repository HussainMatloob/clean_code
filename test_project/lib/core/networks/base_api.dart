import 'package:dio/dio.dart';
import 'package:test_project/core/constants/api_urls.dart';

class BaseApi {
  static final BaseApi _instance = BaseApi._internal();
  static BaseApi get instance => _instance;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      sendTimeout: const Duration(seconds: 120),
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      headers: {'Accepts': 'application/json'},
    ),
  );

  String? _authToken;

  BaseApi._internal();

  static Dio get sendRequest => _instance.dio;

  String? get authToken => _instance._authToken;

  static void setAuthToken(String? token) {
    _instance._authToken = token;
  }
}
