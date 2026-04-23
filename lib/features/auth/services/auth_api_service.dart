import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';

class AuthApiResponse {
  final bool isSuccess;
  final String message;
  final String? sessionId;
  final String? userId;
  final String? status;
  final String? generatedPassword;
  final int statusCode;
  final dynamic rawData;

  const AuthApiResponse({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
    this.sessionId,
    this.userId,
    this.status,
    this.generatedPassword,
    this.rawData,
  });
}

class AuthApiService {
  const AuthApiService();

  Future<AuthApiResponse> login({
    required String username,
    required String password,
  }) {
    return _request(
      endpoint: 'login',
      params: {'username': username, 'password': password},
    );
  }

  Future<AuthApiResponse> signup({required String username, String? password}) {
    final params = <String, String>{'username': username};
    if (password != null && password.isNotEmpty) {
      params['password'] = password;
    }

    return _request(endpoint: 'signup', params: params);
  }

  Future<AuthApiResponse> forgotPassword({required String username}) {
    return _request(endpoint: 'forgotpassword', params: {'username': username});
  }

  Future<AuthApiResponse> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _request(
      endpoint: 'changepassword',
      params: {
        'username': username,
        'password': currentPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
  }

  Future<AuthApiResponse> guest() async {
    final uri = Uri.parse('${AppConstants.apiBaseUrl}/guest');
    try {
      final response = await http
          .get(uri)
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );
      return _parseResponse(response: response);
    } catch (_) {
      return const AuthApiResponse(
        isSuccess: false,
        message: 'Unable to connect to server. Please try again.',
        statusCode: 0,
      );
    }
  }

  Future<AuthApiResponse> _request({
    required String endpoint,
    required Map<String, String> params,
  }) async {
    final uri = Uri.parse(
      '${AppConstants.apiBaseUrl}/$endpoint',
    ).replace(queryParameters: params);

    try {
      final response = await http
          .get(uri)
          .timeout(
            const Duration(milliseconds: AppConstants.connectionTimeout),
          );

      return _parseResponse(response: response);
    } catch (_) {
      return const AuthApiResponse(
        isSuccess: false,
        message: 'Unable to connect to server. Please try again.',
        statusCode: 0,
      );
    }
  }

  AuthApiResponse _parseResponse({required http.Response response}) {
    dynamic decodedBody;
    Map<String, dynamic>? payload;
    String message = 'Request failed. Please try again.';
    String? sessionId;
    String? userId;
    String? status;
    String? generatedPassword;

    try {
      decodedBody = json.decode(response.body);
      payload = _extractPayload(decodedBody);
    } catch (_) {
      payload = null;
    }

    message = payload?['message']?.toString() ?? message;
    sessionId = payload?['session_id']?.toString();
    userId = payload?['uid']?.toString();
    status = payload?['status']?.toString();
    generatedPassword =
        payload?['password']?.toString() ??
        payload?['new_password']?.toString() ??
        payload?['generated_password']?.toString();

    final String allow =
        payload?['allow']?.toString().trim().toLowerCase() ?? '';
    final String normalizedStatus =
        payload?['status']?.toString().trim().toLowerCase() ?? '';
    final String normalizedSessionId = sessionId?.trim().toLowerCase() ?? '';

    final bool hasAllowField = payload?.containsKey('allow') ?? false;
    final bool successByPayload = hasAllowField
        ? allow == 'true'
        : normalizedStatus == 'success' ||
              normalizedSessionId.startsWith('ok_');
    final bool isSuccess = response.statusCode == 200 && successByPayload;

    return AuthApiResponse(
      isSuccess: isSuccess,
      message: message,
      sessionId: sessionId,
      userId: userId,
      status: status,
      generatedPassword: generatedPassword,
      statusCode: response.statusCode,
      rawData: decodedBody,
    );
  }

  Map<String, dynamic>? _extractPayload(dynamic decodedBody) {
    if (decodedBody is Map<String, dynamic>) {
      return decodedBody;
    }

    if (decodedBody is List && decodedBody.isNotEmpty) {
      final firstItem = decodedBody.first;
      if (firstItem is Map<String, dynamic>) {
        return firstItem;
      }
      if (firstItem is Map) {
        return Map<String, dynamic>.from(firstItem);
      }
    }

    return null;
  }
}
