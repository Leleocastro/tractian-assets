// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:assets/models/tree_node_model.dart';

class AssetModel extends TreeNodeModel {
  final String? locationId;
  AssetModel({
    required super.id,
    required super.name,
    super.parentId,
    super.children,
    this.locationId,
  });

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      locationId: map['locationId'] != null ? map['locationId'] as String : null,
      id: map['id'] as String,
      name: map['name'] as String,
      parentId: map['parentId'] as String?,
      children: [],
    );
  }

  @override
  AssetModel copyWith({
    String? locationId,
    String? id,
    String? name,
    String? parentId,
    List<TreeNodeModel>? children,
  }) {
    return AssetModel(
      locationId: locationId ?? this.locationId,
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
    );
  }
}
