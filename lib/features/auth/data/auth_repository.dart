import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:landiq/core/network/api_client.dart';
import 'package:landiq/core/network/token_storage.dart';
import 'package:landiq/features/auth/data/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthRepository({ApiClient? apiClient, TokenStorage? tokenStorage})
      : _apiClient = apiClient ?? ApiClient(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  // Register a new user
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
        },
      );

      final data = response.data;
      log('REGISTER response: $data', name: 'AuthRepository');

      final token = data['token'] ?? '';
      await _tokenStorage.saveAccessToken(token);

      // Fetch full profile after registration
      return await getProfile();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Login with email and password
  Future<User> login({
    required String email,
    required String password,
  }) async {
    // Clear any existing tokens so old sessions don't interfere
    await _tokenStorage.clearTokens();

    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      log('LOGIN status: ${response.statusCode}, response: $data',
          name: 'AuthRepository');

      // Validate we got a token back
      final token = data['token'];
      if (token == null || token.toString().isEmpty) {
        throw 'Login failed: no token received';
      }

      await _tokenStorage.saveAccessToken(token);

      // Fetch full profile after login
      return await getProfile();
    } on DioException catch (e) {
      // Clear any partially saved tokens on failure
      await _tokenStorage.clearTokens();
      throw _handleError(e);
    }
  }

  // Fetch user profile from /api/auth/me
  Future<User> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/auth/me');
      final data = response.data;
      log('PROFILE response: $data', name: 'AuthRepository');

      // Handle both {user: {...}} and direct {...} response shapes
      if (data is Map && data.containsKey('user')) {
        return User.fromJson(data['user']);
      }
      return User.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Logout and clear tokens
  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
    } catch (_) {
      // Even if the API call fails, clear local tokens
    } finally {
      await _tokenStorage.clearTokens();
      // Verify tokens are cleared
      final remaining = await _tokenStorage.getAccessToken();
      log('LOGOUT -- token after clear: $remaining', name: 'AuthRepository');
    }
  }

  // Check if user has stored tokens (for auto-login)
  Future<bool> isAuthenticated() async {
    return await _tokenStorage.hasTokens();
  }

  // Clear all stored tokens
  Future<void> clearSession() async {
    await _tokenStorage.clearTokens();
  }

  // Extract a user-friendly error message from DioException
  String _handleError(DioException e) {
    log('API error: ${e.response?.statusCode} ${e.response?.data}',
        name: 'AuthRepository');
    if (e.response?.data != null && e.response?.data is Map) {
      final data = e.response!.data as Map;
      return data['error'] ?? data['message'] ?? 'Something went wrong';
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Please try again.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }
    return 'Something went wrong. Please try again.';
  }
}
