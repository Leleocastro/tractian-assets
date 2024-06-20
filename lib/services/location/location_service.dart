import 'package:assets/models/location_model.dart';
import 'package:assets/utils/main_exception.dart';
import 'package:dio/dio.dart';

class LocationService {
  final Dio _dio;
  const LocationService(this._dio);

  Future<(List<LocationModel>?, MainException?)> fetchLocations(String companyId) async {
    try {
      final response = await _dio.get('/companies/$companyId/locations');

      final locations = (response.data as List).map((e) => LocationModel.fromMap(e as Map<String, dynamic>)).toList();

      return (locations, null);
    } catch (e) {
      return (null, MainException(e.toString()));
    }
  }
}
