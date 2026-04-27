import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../core/network/dio_client.dart';

final dioClientProvider = Provider((ref) => DioClient());

final authServiceProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthService(dioClient.dio);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

class AuthState {
  final bool isLoading;
  final String? error;
  final User? user;

  AuthState({this.isLoading = false, this.error, this.user});

  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState()) {
    _checkSavedToken();
  }

  Future<void> _checkSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final username = prefs.getString('auth_username');
    final role = prefs.getString('auth_role');

    if (token != null && token.isNotEmpty && !token.startsWith('<')) {
      state = state.copyWith(
        user: User(
          username: username ?? 'Admin',
          role: role ?? 'ADMIN',
          token: token,
        ),
      );
    }
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authService.login(username, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', user.token);
      await prefs.setString('auth_username', user.username);
      await prefs.setString('auth_role', user.role);

      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_username');
    await prefs.remove('auth_role');
    state = AuthState();
  }
}