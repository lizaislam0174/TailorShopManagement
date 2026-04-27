import 'package:dio/dio.dart';
import '../models/measurement.dart';
import '../core/network/api_config.dart';

class MeasurementService {
  final Dio _dio;

  MeasurementService(this._dio);

  Future<Measurement?> getByCustomerId(int customerId) async {
    try {
      final response = await _dio.get('${ApiConfig.measurements}/customer/$customerId');
      if (response.data != null) {
        return Measurement.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Measurement> createOrUpdateMeasurement(Measurement measurement) async {
    final response = await _dio.post(ApiConfig.measurements, data: measurement.toJson());
    return Measurement.fromJson(response.data);
  }
}
