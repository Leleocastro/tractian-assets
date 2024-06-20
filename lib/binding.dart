import 'package:assets/pages/assets/assets_controller.dart';
import 'package:assets/pages/menu/company_controller.dart';
import 'package:assets/services/asset/asset_component_service.dart';
import 'package:assets/services/company/company_service.dart';
import 'package:assets/services/location/location_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initBinding() async {
  getIt
    ..registerSingleton(
      Dio(
        BaseOptions(baseUrl: 'https://fake-api.tractian.com'),
      ),
    )
    ..registerFactory(() => AssetComponentService(getIt()))
    ..registerFactory(() => CompanyService(getIt()))
    ..registerFactory(() => LocationService(getIt()))
    ..registerFactory(() => CompanyController(getIt()))
    ..registerFactory(() => AssetsController(getIt(), getIt()));
}
