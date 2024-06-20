// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:assets/models/tree_node_model.dart';

class LocationModel extends TreeNodeModel {
  LocationModel({
    required super.id,
    required super.name,
    super.parentId,
    super.children,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] as String,
      name: map['name'] as String,
      parentId: map['parentId'] as String?,
      children: [],
    );
  }

  @override
  LocationModel copyWith({
    String? id,
    String? name,
    String? parentId,
    List<TreeNodeModel>? children,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
    );
  }
}
