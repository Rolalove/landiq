import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landiq/core/network/token_storage.dart';
import 'package:landiq/features/auth/data/auth_repository.dart';
import 'package:landiq/features/auth/data/user_model.dart';

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Token storage provider
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

// Auth state
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    // Auto-login on construction — keeps user logged in across app restarts
    tryAutoLogin();
  }

  // Register a new user
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      state = AsyncValue.data(user);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.login(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  // Try auto-login by checking stored token + fetching profile
  Future<bool> tryAutoLogin() async {
    final hasToken = await _repository.isAuthenticated();
    if (!hasToken) return false;

    try {
      final user = await _repository.getProfile();
      state = AsyncValue.data(user);
      return true;
    } catch (_) {
      // Token expired or invalid — clear it
      await _repository.clearSession();
      state = const AsyncValue.data(null);
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncValue.data(null);
  }
}
