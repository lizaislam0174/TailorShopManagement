import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');

          if (token != null && token.isNotEmpty && !token.startsWith('<')) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          final data = e.response?.data;
          if (data != null && data.toString().contains('<!DOCTYPE')) {
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                response: e.response,
                message: "Server returned HTML instead of JSON. Check backend is running and URL is correct.",
                type: DioExceptionType.badResponse,
              ),
            );
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}