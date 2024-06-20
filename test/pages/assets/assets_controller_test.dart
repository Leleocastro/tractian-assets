import 'package:assets/models/asset_model.dart';
import 'package:assets/models/component_model.dart';
import 'package:assets/models/location_model.dart';
import 'package:assets/models/tree_node_model.dart';
import 'package:assets/pages/assets/assets_controller.dart';
import 'package:assets/services/asset/asset_component_service.dart';
import 'package:assets/services/location/location_service.dart';
import 'package:assets/utils/main_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocationServiceMock extends Mock implements LocationService {}

class AssetComponentServiceMock extends Mock implements AssetComponentService {}

void main() async {
  var locations = [
    {"id": "656a07b3f2d4a1001e2144bf", "name": "CHARCOAL STORAGE SECTOR", "parentId": "65674204664c41001e91ecb4"},
    {"id": "656733611f4664001f295dd0", "name": "Empty Machine house", "parentId": null},
    {"id": "656733b1664c41001e91d9ed", "name": "Machinery house", "parentId": null},
    {"id": "65674204664c41001e91ecb4", "name": "PRODUCTION AREA - RAW MATERIAL", "parentId": null}
  ];

  final assetsAndComponents = [
    {
      "id": "656a07bbf2d4a1001e2144c2",
      "locationId": "656a07b3f2d4a1001e2144bf",
      "name": "CONVEYOR BELT ASSEMBLY",
      "parentId": null,
      "sensorType": null,
      "status": null
    },
    {
      "gatewayId": "QHI640",
      "id": "656734821f4664001f296973",
      "locationId": null,
      "name": "Fan - External",
      "parentId": null,
      "sensorId": "MTC052",
      "sensorType": "energy",
      "status": "operating"
    },
    {"id": "656734448eb037001e474a62", "locationId": "656733b1664c41001e91d9ed", "name": "Fan H12D", "parentId": null, "sensorType": null, "status": null},
    {
      "gatewayId": "FRH546",
      "id": "656a07cdc50ec9001e84167b",
      "locationId": null,
      "name": "MOTOR RT COAL AF01",
      "parentId": "656a07c3f2d4a1001e2144c5",
      "sensorId": "FIJ309",
      "sensorType": "vibration",
      "status": "operating"
    },
    {
      "id": "656a07c3f2d4a1001e2144c5",
      "locationId": null,
      "name": "MOTOR TC01 COAL UNLOADING AF02",
      "parentId": "656a07bbf2d4a1001e2144c2",
      "sensorType": null,
      "status": null
    },
    {
      "gatewayId": "QBK282",
      "id": "6567340c1f4664001f29622e",
      "locationId": null,
      "name": "Motor H12D- Stage 1",
      "parentId": "656734968eb037001e474d5a",
      "sensorId": "CFX848",
      "sensorType": "vibration",
      "status": "alert"
    },
    {
      "gatewayId": "VHS387",
      "id": "6567340c664c41001e91dceb",
      "locationId": null,
      "name": "Motor H12D-Stage 2",
      "parentId": "656734968eb037001e474d5a",
      "sensorId": "GYB119",
      "sensorType": "vibration",
      "status": "alert"
    },
    {
      "gatewayId": "VZO694",
      "id": "656733921f4664001f295e9b",
      "locationId": null,
      "name": "Motor H12D-Stage 3",
      "parentId": "656734968eb037001e474d5a",
      "sensorId": "SIF016",
      "sensorType": "vibration",
      "status": "alert"
    },
    {"id": "656734968eb037001e474d5a", "locationId": "656733b1664c41001e91d9ed", "name": "Motors H12D", "parentId": null, "sensorType": null, "status": null}
  ];

  int verifyQuantityItemsTree(List<TreeNodeModel> children) {
    int count = 0;
    for (var child in children) {
      count++;
      count += verifyQuantityItemsTree(child.children);
    }
    return count;
  }

  late final LocationService locationService;
  late final AssetComponentService assetService;
  late final AssetsController controller;

  setUpAll(() {
    locationService = LocationServiceMock();
    assetService = AssetComponentServiceMock();
    controller = AssetsController(locationService, assetService);
  });

  tearDown(() {
    controller.listenError.value = '';
  });

  group('AssetsController.fetch', () {
    test('error when fetching Location', () async {
      when(() => locationService.fetchLocations(any())).thenAnswer((_) async => (null, MainException('error')));

      await controller.fetch('1');
      expect(controller.listenError.value, 'error');
    });
    test('error when fetching Assets and Components', () async {
      when(() => locationService.fetchLocations(any())).thenAnswer((_) async => (<LocationModel>[], null));
      when(() => assetService.fetchAssetsAndComponents(any())).thenAnswer((_) async => (null, MainException('error')));

      await controller.fetch('1');
      expect(controller.listenError.value, 'error');
    });
    test('error when fetching Locations, Assets and Components', () async {
      when(() => locationService.fetchLocations(any())).thenAnswer((_) async => (null, null));
      when(() => assetService.fetchAssetsAndComponents(any())).thenAnswer((_) async => (null, null));
      await controller.fetch('1');
      expect(controller.listenError.value, 'No data found');
    });

    test('Locations and Sub-Locations', () async {
      when(() => locationService.fetchLocations(any())).thenAnswer((_) async => (locations.map((e) => LocationModel.fromMap(e)).toList(), null));
      when(() => assetService.fetchAssetsAndComponents(any())).thenAnswer((_) async => (<TreeNodeModel>[], null));

      await controller.fetch('1');
      expect(controller.root.children.length, 3);
      expect(controller.root.children[0].children.length, 1);
    });

    test('Tree of Locations, Assets and Components', () async {
      when(() => locationService.fetchLocations(any())).thenAnswer((_) async => (locations.map((e) => LocationModel.fromMap(e)).toList(), null));
      when(() => assetService.fetchAssetsAndComponents(any())).thenAnswer((_) async => (
            assetsAndComponents.map((item) {
              if (item['sensorType'] != null) {
                return ComponentModel.fromMap(item);
              } else {
                return AssetModel.fromMap(item);
              }
            }).toList(),
            null
          ));

      await controller.fetch('1');
      expect(verifyQuantityItemsTree(controller.root.children), 13);
      expect(controller.root.children.length, 4);
      expect(controller.root.children[0], isA<LocationModel>());
      expect(controller.root.children[0].children.length, 2);
      expect(controller.root.children[0].children[0], isA<AssetModel>());
      expect(controller.root.children[0].children[0].children.length, 0);
      expect(controller.root.children[0].children[1], isA<AssetModel>());
      expect(controller.root.children[0].children[1].children.length, 3);
      expect(controller.root.children[0].children[1].children[0], isA<ComponentModel>());
      expect(controller.root.children[0].children[1].children[0].children.length, 0);
      expect(controller.root.children[0].children[1].children[1], isA<ComponentModel>());
      expect(controller.root.children[0].children[1].children[1].children.length, 0);
      expect(controller.root.children[0].children[1].children[2], isA<ComponentModel>());
      expect(controller.root.children[0].children[1].children[2].children.length, 0);
      expect(controller.root.children[1], isA<LocationModel>());
      expect(controller.root.children[1].children.length, 1);
      expect(controller.root.children[1].children[0], isA<LocationModel>());
      expect(controller.root.children[1].children[0].children.length, 1);
      expect(controller.root.children[1].children[0].children[0], isA<AssetModel>());
      expect(controller.root.children[1].children[0].children[0].children.length, 1);
      expect(controller.root.children[1].children[0].children[0].children[0], isA<AssetModel>());
      expect(controller.root.children[1].children[0].children[0].children[0].children.length, 1);
      expect(controller.root.children[1].children[0].children[0].children[0].children[0], isA<ComponentModel>());
      expect(controller.root.children[1].children[0].children[0].children[0].children[0].children.length, 0);
      expect(controller.root.children[2], isA<LocationModel>());
      expect(controller.root.children[2].children.length, 0);
      expect(controller.root.children[3], isA<ComponentModel>());
      expect(controller.root.children[3].children.length, 0);
    });
  });
}
