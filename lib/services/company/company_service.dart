import 'package:assets/models/company_model.dart';
import 'package:assets/utils/main_exception.dart';
import 'package:dio/dio.dart';

class CompanyService {
  final Dio _dio;
  const CompanyService(this._dio);

  Future<(List<CompanyModel>?, MainException?)> fetchCompanies() async {
    try {
      final response = await _dio.get('/companies');

      final companies = (response.data as List).map((e) => CompanyModel.fromMap(e as Map<String, dynamic>)).toList();

      return (companies, null);
    } catch (e) {
      return (null, MainException(e.toString()));
    }
  }
}
