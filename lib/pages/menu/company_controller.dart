import 'package:assets/models/company_model.dart';
import 'package:assets/services/company/company_service.dart';
import 'package:get/get.dart';

class CompanyController extends GetxController {
  CompanyController(this._service);
  final CompanyService _service;

  final _companies = <CompanyModel>[].obs;
  RxList<CompanyModel> get companies => _companies;

  final _loading = false.obs;
  bool get loading => _loading.value;

  Future<void> fetchCompanies() async {
    _loading.value = true;
    final (res, err) = await _service.fetchCompanies();
    if (err != null) {
      Get.snackbar('Error', err.message);
      _loading.value = false;
      return;
    }
    if (res == null) {
      Get.snackbar('Error', 'No data found');
      _loading.value = false;
      return;
    }
    _companies.clear();
    _companies.addAll(res);
    _loading.value = false;
  }
}
