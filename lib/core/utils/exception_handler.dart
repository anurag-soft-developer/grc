import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grc/core/config/constants.dart';

class ExceptionHandler {
  static void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(AppColors.error),
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  static void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(AppColors.success),
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  static void showInfoToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(AppColors.primary),
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  static String handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network settings.';
      case DioExceptionType.badResponse:
        final responseData = e.response?.data;
        if (responseData is Map &&
            responseData['errors'] is List &&
            (responseData['errors'] as List).isNotEmpty) {
          final message = (responseData['errors'] as List).first['message'];
          if (message is String) return message;
        }
        if (responseData is Map && responseData['message'] != null) {
          return responseData['message'].toString();
        }
        return AppConstants.errorMessages.unknown;
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.unknown:
      default:
        return AppConstants.errorMessages.unknown;
    }
  }

  static String handleGenericException(dynamic e) {
    if (e is DioException) return handleDioException(e);
    return e.toString().replaceAll('Exception: ', '');
  }

  static void handleException(dynamic e) {
    debugPrint('[Exception]: $e');
    showErrorToast(handleGenericException(e));
  }

  static Never throwException(dynamic e) {
    handleException(e);
    throw e;
  }
}
