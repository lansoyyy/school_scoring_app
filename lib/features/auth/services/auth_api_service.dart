import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';

class AuthApiResponse {
  final bool isSuccess;
  final String message;
  final String? sessionId;
  final String? status;
  final int statusCode;
  final dynamic rawData;

  const AuthApiResponse({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
    this.sessionId,
    this.status,
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
      expectedSessionId: 'Ok_Login',
      params: {'username': username, 'password': password},
    );
  }

  Future<AuthApiResponse> signup({
    required String username,
    required String password,
  }) {
    return _request(
      endpoint: 'signup',
      expectedSessionId: 'Ok_Signup',
      params: <String, String>{'username': username, 'password': password},
    );
  }

  Future<AuthApiResponse> changePassword({required String username}) {
    return _request(
      endpoint: 'changepassword',
      expectedSessionId: 'Ok_ChangePassword',
      params: {'username': username},
    );
  }

  Future<AuthApiResponse> _request({
    required String endpoint,
    required String expectedSessionId,
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

      return _parseResponse(
        response: response,
        expectedSessionId: expectedSessionId,
      );
    } catch (_) {
      return const AuthApiResponse(
        isSuccess: false,
        message: 'Unable to connect to server. Please try again.',
        statusCode: 0,
      );
    }
  }

  AuthApiResponse _parseResponse({
    required http.Response response,
    required String expectedSessionId,
  }) {
    dynamic decodedBody;
    Map<String, dynamic>? payload;
    String message = 'Request failed. Please try again.';
    String? sessionId;
    String? status;

    try {
      decodedBody = json.decode(response.body);
      payload = _extractPayload(decodedBody);
    } catch (_) {
      payload = null;
    }

    message = payload?['message']?.toString() ?? message;
    sessionId = payload?['session_id']?.toString();
    status = payload?['status']?.toString();

    final normalizedStatus = status?.toLowerCase() ?? '';
    final normalizedSession = sessionId?.toLowerCase() ?? '';
    final normalizedExpectedSession = expectedSessionId.toLowerCase();

    final bool successByBody =
        normalizedSession == normalizedExpectedSession ||
        (normalizedSession.startsWith('ok_') &&
            normalizedStatus == 'success') ||
        (normalizedExpectedSession == 'ok_login' &&
            normalizedSession.startsWith('ok_'));

    final bool isSuccess = response.statusCode == 200 && successByBody;

    return AuthApiResponse(
      isSuccess: isSuccess,
      message: message,
      sessionId: sessionId,
      status: status,
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
