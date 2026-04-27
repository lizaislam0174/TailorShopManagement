import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _host = '10.0.2.2:8080';

  static const String _basePath = '/api';

  static String get baseUrl {
    String base = kIsWeb ? 'http://localhost:8080' : 'http://$_host';
    String path = _basePath;

    // Ensure path starts with / and ends with /
    if (path.isNotEmpty && !path.startsWith('/')) path = '/$path';
    if (!path.endsWith('/')) path = '$path/';

    return '$base$path';
  }

  // Endpoints (No leading slashes)
  static const String login = 'auth/login';
  static const String dashboard = 'dashboard';
  static const String customers = 'customers';
  static const String employees = 'employees';
  static const String orders = 'orders';
  static const String payments = 'payments';
  static const String measurements = 'measurements';
}