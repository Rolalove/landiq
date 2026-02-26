import 'dart:developer';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:landiq/core/network/token_storage.dart';

class ApiClient {
  static const String baseUrl =
      'https://wtf-landiq-production.up.railway.app/api';

  final Dio dio;
  final TokenStorage _tokenStorage;
  final CookieJar cookieJar;

  bool _isRefreshing = false;

  // Singleton so the cookie jar persists across the app
  static ApiClient? _instance;
  factory ApiClient({TokenStorage? tokenStorage}) {
    _instance ??= ApiClient._internal(tokenStorage: tokenStorage);
    return _instance!;
  }

  ApiClient._internal({TokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? TokenStorage(),
        cookieJar = CookieJar(),
        dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    // Cookie manager — stores and sends cookies (refresh token)
    dio.interceptors.add(CookieManager(cookieJar));
    // Auth interceptor — attaches Bearer access token
    dio.interceptors.add(_authInterceptor());
    // Refresh interceptor — auto-refreshes on 401
    dio.interceptors.add(_refreshInterceptor());
  }

  // Attaches the access token to every request
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenStorage.getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    );
  }

  // Handles 401 responses by refreshing the access token and retrying
  Interceptor _refreshInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        // Only handle 401 Unauthorized (expired access token)
        if (error.response?.statusCode != 401) {
          return handler.next(error);
        }

        // Skip refresh for auth endpoints (login, register, refresh itself)
        final path = error.requestOptions.path;
        if (path.contains('/auth/login') ||
            path.contains('/auth/register') ||
            path.contains('/auth/refresh')) {
          return handler.next(error);
        }

        // Prevent concurrent refresh attempts
        if (_isRefreshing) {
          return handler.next(error);
        }

        _isRefreshing = true;
        log('Access token expired, attempting refresh...', name: 'ApiClient');

        try {
          // Call refresh endpoint — the cookie jar sends the refresh token cookie
          final refreshResponse = await dio.post('/auth/refresh');
          final data = refreshResponse.data;

          // Extract new access token
          final newToken = data['token'] ?? data['accessToken'] ?? data['access_token'];
          if (newToken == null || newToken.toString().isEmpty) {
            log('Refresh failed: no token in response', name: 'ApiClient');
            _isRefreshing = false;
            return handler.next(error);
          }

          await _tokenStorage.saveAccessToken(newToken);
          log('Token refreshed successfully', name: 'ApiClient');

          _isRefreshing = false;

          // Retry the original request with the new token
          final opts = error.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';

          final retryResponse = await dio.fetch(opts);
          return handler.resolve(retryResponse);
        } catch (refreshError) {
          _isRefreshing = false;
          log('Token refresh failed: $refreshError', name: 'ApiClient');

          // Clear tokens — user needs to log in again
          await _tokenStorage.clearTokens();
          return handler.next(error);
        }
      },
    );
  }
}
