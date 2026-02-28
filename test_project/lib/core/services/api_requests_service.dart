import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_project/core/exceptions/app_exceptions.dart';
import 'package:test_project/core/networks/base_api.dart';

class ApiRequest {
  final Dio _dio = BaseApi.sendRequest;

  /*---------------------------------------------------------*/
  /*                global get api request function          */
  /*---------------------------------------------------------*/
  Future<Response> getRequest(
    String apiPath, {
    Map<String, dynamic>? queryParameters,
    bool isAuthenticated = false,
  }) async {
    debugPrint("Api path : $apiPath");
    print(queryParameters);
    try {
      _setAuthHeader(isAuthenticated);

      final response = await _dio.get(
        apiPath,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      debugPrint("dio exception occured: ${e.message}");
      throw AppExceptions.handleDioError(e);
    } catch (e) {
      debugPrint("init catch  exception is : ${e.runtimeType}");
      rethrow;
    }
  }

  /*---------------------------------------------------------*/
  /*                global post api request function         */
  /*---------------------------------------------------------*/
  Future<Response> postRequest(
    String apiPath, {
    Map<String, dynamic>? queryParameters,
    bool isAuthenticated = false,
  }) async {
    debugPrint("-------Api path : $apiPath");
    print(queryParameters);
    try {
      _setAuthHeader(isAuthenticated);

      final response = await _dio.post(apiPath, data: queryParameters);

      return response;
    } on DioException catch (e) {
      throw AppExceptions.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  /*---------------------------------------------------------*/
  /*         global multicast post api request function      */
  /*---------------------------------------------------------*/
  Future<Response> multicastPostRequest(
    String apiPath, {

    bool isAuthenticated = false,
    File? image,
  }) async {
    debugPrint("Api path : $apiPath");

    try {
      _setAuthHeader(isAuthenticated);

      MultipartFile? iconMultipart;
      if (image != null) {
        iconMultipart = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split("/").last,
        );
      }

      final formData = FormData.fromMap({
        if (iconMultipart != null) "icon": iconMultipart,
      });

      final response = await _dio.post(apiPath, data: formData);
      return response;
    } on DioException catch (e) {
      throw AppExceptions.handleDioError(e);
    }
  }

  /*---------------------------------------------------------*/
  /*  global multicast multimedia post api request function  */
  /*---------------------------------------------------------*/
  Future<Response> mediaListmulticastPostRequest(
    String apiPath, {
    bool isAuthenticated = false,
    List<File>? mediaFiles, // plural
  }) async {
    debugPrint("Api path : $apiPath");

    try {
      _setAuthHeader(isAuthenticated);

      List<MultipartFile> files = [];

      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (var file in mediaFiles) {
          files.add(
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split("/").last,
            ),
          );
        }
      }

      final formData = FormData.fromMap({
        if (files.isNotEmpty) "files": files, // <-- multiple files
      });

      final response = await _dio.post(apiPath, data: formData);

      return response;
    } on DioException catch (e) {
      throw AppExceptions.handleDioError(e);
    }
  }

  /*---------------------------------------------------------*/
  /*                global put api request function          */
  /*---------------------------------------------------------*/
  Future<Response> putRequest(
    String apiPath, {
    Map<String, dynamic>? data,
    bool isAuthenticated = false,
  }) async {
    try {
      _setAuthHeader(isAuthenticated);

      final response = await _dio.patch(apiPath, data: data);

      return response;
    } on DioException catch (e) {
      throw AppExceptions.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  /*---------------------------------------------------------*/
  /*                global delete api request function       */
  /*---------------------------------------------------------*/
  Future<Response> deleteRequest(
    String apiPath, {
    Map<String, dynamic>? data,
    bool isAuthenticated = false,
  }) async {
    try {
      _setAuthHeader(isAuthenticated);

      final response = await _dio.delete(apiPath, data: data);

      return response;
    } on DioException catch (e) {
      throw AppExceptions.handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  /*---------------------------------------------------------*/
  /*                     set user auth token globally        */
  /*---------------------------------------------------------*/
  void _setAuthHeader(bool isAuthenticated) {
    final baseApi = BaseApi.instance;
    if (isAuthenticated && baseApi.authToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer ${baseApi.authToken}';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }
}
