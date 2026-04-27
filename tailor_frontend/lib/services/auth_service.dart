import 'package:dio/dio.dart';
import '../core/network/api_config.dart';
import '../models/user.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<User> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiConfig.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        
        // Handle Map response
        if (data is Map<String, dynamic>) {
          // Check for token in various common keys
          String? token = data['token'] ?? data['accessToken'] ?? data['jwt'];
          if (token != null) {
            return User(
              username: data['username'] ?? username,
              role: data['role'] ?? 'ADMIN',
              token: token,
            );
          }
          // If the map is the user object but doesn't have token at top level
          if (data.containsKey('data')) {
            final nestedData = data['data'];
            if (nestedData is Map<String, dynamic>) {
               String? nestedToken = nestedData['token'] ?? nestedData['accessToken'];
               if (nestedToken != null) {
                  return User(
                    username: nestedData['username'] ?? username,
                    role: nestedData['role'] ?? 'ADMIN',
                    token: nestedToken,
                  );
               }
            }
          }
        } 
        // Handle plain string response (the token itself)
        else if (data is String && data.length > 20 && !data.startsWith('<')) {
          return User(
            username: username,
            role: 'ADMIN',
            token: data.trim(),
          );
        }
        
        throw Exception('Invalid response format. Server sent: ${data.toString().substring(0, data.toString().length > 50 ? 50 : data.toString().length)}');
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData is Map) {
          throw Exception(errorData['message'] ?? errorData['error'] ?? 'Invalid credentials');
        }
        if (e.response?.statusCode == 401) throw Exception('Invalid username or password');
        if (e.response?.statusCode == 404) throw Exception('Login endpoint not found. Check API path.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
