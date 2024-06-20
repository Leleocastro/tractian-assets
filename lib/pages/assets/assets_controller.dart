import 'package:assets/models/asset_model.dart';
import 'package:assets/models/component_model.dart';
import 'package:assets/models/tree_node_model.dart';
import 'package:assets/services/asset/asset_component_service.dart';
import 'package:assets/services/location/location_service.dart';
import 'package:get/get.dart';

class AssetsController extends GetxController {
  final LocationService _locationService;
  final AssetComponentService _assetService;
  AssetsController(this._locationService, this._assetService);

  final _loading = false.obs;
  bool get loading => _loading.value;

  final listenError = ''.obs;

  final _root = TreeNodeModel(id: '1', name: 'Root').obs;
  TreeNodeModel _mainRoot = TreeNodeModel(id: '1', name: 'Root');

  TreeNodeModel get root => _root.value;

  String query = '';
  String type = '';
  String status = '';

  Future<void> fetch(String companyId) async {
    _loading.value = true;
    final (locations, errLoc) = await _locationService.fetchLocations(companyId);
    if (errLoc != null) {
      listenError.value = errLoc.message;
      _loading.value = false;
      return;
    }

    final (assets, errAss) = await _assetService.fetchAssetsAndComponents(companyId);

    if (errAss != null) {
      listenError.value = errAss.message;
      _loading.value = false;
      return;
    }

    if (locations == null && assets == null) {
      listenError.value = 'No data found';
      _loading.value = false;
      return;
    }

    _buildTree(locations ?? [], assets ?? []);
    _loading.value = false;
  }

  void filter() {
    _root.value = _filterTree(_mainRoot) ?? TreeNodeModel(id: '1', name: 'Root');
  }

  TreeNodeModel? _filterTree(TreeNodeModel node) {
    List<TreeNodeModel> filteredChildren = node.children.map((child) => _filterTree(child)).where((child) => child != null).cast<TreeNodeModel>().toList();

    bool matchesQuery = node.name.toLowerCase().contains(query.toLowerCase());
    bool matchesType = type.isEmpty || (node is ComponentModel && node.sensorType == type);
    bool matchesStatus = status.isEmpty || (node is ComponentModel && node.status == status);

    if ((matchesQuery && matchesType && matchesStatus) || filteredChildren.isNotEmpty) {
      return node.copyWith(
        children: filteredChildren,
      );
    }

    return null;
  }

  void _buildTree(List<TreeNodeModel> locations, List<TreeNodeModel> assetsAndComponents) {
    Map<String, TreeNodeModel> nodes = {};

    for (var location in locations) {
      nodes[location.id] = location;
    }

    for (var node in assetsAndComponents) {
      nodes[node.id] = node;
    }

    _mainRoot = TreeNodeModel(id: '1', name: 'Root', children: []);

    for (var location in locations) {
      if (location.parentId == null) {
        _mainRoot.children.add(location);
      } else {
        nodes[location.parentId]?.children.add(location);
      }
    }

    for (var node in assetsAndComponents) {
      if (node is AssetModel) {
        if (node.parentId == null && node.locationId == null) {
          _mainRoot.children.add(node);
        } else if (node.parentId != null) {
          nodes[node.parentId]?.children.add(node);
        } else if (node.locationId != null) {
          nodes[node.locationId]?.children.add(node);
        }
      } else if (node is ComponentModel) {
        if (node.parentId == null && node.locationId == null) {
          _mainRoot.children.add(node);
        } else if (node.parentId != null) {
          nodes[node.parentId]?.children.add(node);
        } else if (node.locationId != null) {
          nodes[node.locationId]?.children.add(node);
        }
      }
    }

    _mainRoot.children.sort((a, b) {
      bool aHasChildren = a.children.isNotEmpty;
      bool bHasChildren = b.children.isNotEmpty;
      if (aHasChildren && !bHasChildren) return -1;
      if (!aHasChildren && bHasChildren) return 1;
      return 0;
    });

    _root.value = _mainRoot.copyWith();
  }
}
