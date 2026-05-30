import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:grc/core/config/api_constants.dart';
import 'package:grc/core/services/auth_storage_service.dart';
import 'package:grc/core/utils/exception_handler.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio = _setupDio();
  late final Dio _refreshDio = _setupRefreshDio();
  final AuthStorageService _authStorageService = AuthStorageService();
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  Dio _setupDio() {
    final dioInstance = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.requestTimeout,
        headers: ApiConstants.defaultHeaders,
      ),
    );

    dioInstance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authStorageService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (options.data != null) {
            options.data = _removeNullValues(options.data);
          }
          if (options.queryParameters.isNotEmpty) {
            final cleaned = _removeNullValues(options.queryParameters);
            options.queryParameters = cleaned is Map<String, dynamic>
                ? cleaned
                : <String, dynamic>{};
          }
          handler.next(options);
        },
        onError: (err, handler) async {
          final statusCode = err.response?.statusCode;
          final requestOptions = err.requestOptions;
          final isUnauthorized = statusCode == 401;
          final isRefreshRequest =
              requestOptions.path == ApiConstants.auth.refreshToken;
          final hasRetried = requestOptions.extra['retryWithRefresh'] == true;

          if (!isUnauthorized || isRefreshRequest || hasRetried) {
            handler.next(err);
            return;
          }

          final refreshSuccess = await _refreshTokenWithLock();
          if (!refreshSuccess) {
            handler.next(err);
            return;
          }

          final newToken = await _authStorageService.getAccessToken();
          if (newToken == null || newToken.isEmpty) {
            handler.next(err);
            return;
          }

          requestOptions.headers['Authorization'] = 'Bearer $newToken';
          requestOptions.extra['retryWithRefresh'] = true;

          try {
            final retryResponse = await _dio.fetch<dynamic>(requestOptions);
            handler.resolve(retryResponse);
          } catch (retryError) {
            if (retryError is DioException) {
              handler.next(retryError);
              return;
            }
            handler.next(err);
          }
        },
      ),
    );

    if (kDebugMode) {
      dioInstance.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) => debugPrint('[API] $object'),
        ),
      );
    }

    return dioInstance;
  }

  Dio _setupRefreshDio() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.requestTimeout,
        headers: ApiConstants.defaultHeaders,
      ),
    );
  }

  Future<bool> _refreshTokenWithLock() async {
    if (_isRefreshing) {
      final completer = _refreshCompleter;
      if (completer == null) return false;
      return completer.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final success = await _refreshAccessToken();
      _refreshCompleter?.complete(success);
      return success;
    } catch (_) {
      _refreshCompleter?.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await _authStorageService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _authStorageService.clearAuthData();
        return false;
      }

      final response = await _refreshDio.post<Map<String, dynamic>>(
        ApiConstants.auth.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data;
      final newAccessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        await _authStorageService.clearAuthData();
        return false;
      }

      await _authStorageService.setAccessToken(newAccessToken);
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await _authStorageService.setRefreshToken(newRefreshToken);
      }

      return true;
    } catch (_) {
      await _authStorageService.clearAuthData();
      return false;
    }
  }

  Future<T?> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      ExceptionHandler.handleException(e);
      return null;
    }
  }

  Future<T?> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      ExceptionHandler.handleException(e);
      return null;
    }
  }

  Future<T?> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      ExceptionHandler.handleException(e);
      return null;
    }
  }

  Future<T?> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      ExceptionHandler.handleException(e);
      return null;
    }
  }

  Future<bool> deleteResource(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      );
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      ExceptionHandler.handleException(e);
      return false;
    }
  }

  static dynamic _removeNullValues(dynamic data) {
    if (data is Map<String, dynamic>) {
      final filtered = <String, dynamic>{};
      for (final entry in data.entries) {
        final value = _removeNullValues(entry.value);
        if (value != null) filtered[entry.key] = value;
      }
      return filtered;
    } else if (data is List) {
      return data.map(_removeNullValues).toList();
    }
    return data;
  }
}
