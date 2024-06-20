// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:assets/models/tree_node_model.dart';

class ComponentModel extends TreeNodeModel {
  final String? locationId;
  final String? sensorId;
  final String? sensorType;
  final String? status;
  final String? gatewayId;

  ComponentModel({
    required super.id,
    required super.name,
    super.parentId,
    super.children,
    this.locationId,
    this.sensorId,
    this.sensorType,
    this.status,
    this.gatewayId,
  });

  factory ComponentModel.fromMap(Map<String, dynamic> map) {
    return ComponentModel(
      locationId: map['locationId'] != null ? map['locationId'] as String : null,
      sensorId: map['sensorId'] != null ? map['sensorId'] as String : null,
      sensorType: map['sensorType'] != null ? map['sensorType'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      gatewayId: map['gatewayId'] != null ? map['gatewayId'] as String : null,
      id: map['id'] as String,
      name: map['name'] as String,
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
      children: [],
    );
  }

  @override
  ComponentModel copyWith({
    String? locationId,
    String? sensorId,
    String? sensorType,
    String? status,
    String? gatewayId,
    String? id,
    String? name,
    String? parentId,
    List<TreeNodeModel>? children,
  }) {
    return ComponentModel(
      locationId: locationId ?? this.locationId,
      sensorId: sensorId ?? this.sensorId,
      sensorType: sensorType ?? this.sensorType,
      status: status ?? this.status,
      gatewayId: gatewayId ?? this.gatewayId,
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
    );
  }
}
