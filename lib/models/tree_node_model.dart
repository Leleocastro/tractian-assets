// ignore_for_file: public_member_api_docs, sort_constructors_first

class TreeNodeModel {
  final String id;
  final String name;
  final String? parentId;
  final List<TreeNodeModel> children;

  TreeNodeModel({
    required this.id,
    required this.name,
    this.parentId,
    this.children = const [],
  });

  factory TreeNodeModel.fromMap(Map<String, dynamic> map) {
    return TreeNodeModel(
      id: map['id'] as String,
      name: map['name'] as String,
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
      children: map['children'] != null
          ? List<TreeNodeModel>.from(
              (map['children'] as List<int>).map<TreeNodeModel>(
                (x) => TreeNodeModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  TreeNodeModel copyWith({
    String? id,
    String? name,
    String? parentId,
    List<TreeNodeModel>? children,
  }) {
    return TreeNodeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
    );
  }
}
