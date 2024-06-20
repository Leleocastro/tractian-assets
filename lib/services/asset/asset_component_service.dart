import 'package:assets/models/asset_model.dart';
import 'package:assets/models/component_model.dart';
import 'package:assets/models/tree_node_model.dart';
import 'package:assets/utils/main_exception.dart';
import 'package:dio/dio.dart';

class AssetComponentService {
  final Dio _dio;
  const AssetComponentService(this._dio);

  Future<(List<TreeNodeModel>?, MainException?)> fetchAssetsAndComponents(String companyId) async {
    try {
      final response = await _dio.get('/companies/$companyId/assets');

      final assetsAndComponents = (response.data as List).map((item) {
        if (item['sensorType'] != null) {
          return ComponentModel.fromMap(item);
        } else {
          return AssetModel.fromMap(item);
        }
      }).toList();

      return (assetsAndComponents, null);
    } catch (e) {
      return (null, MainException(e.toString()));
    }
  }
}
