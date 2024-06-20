// ignore_for_file: public_member_api_docs, sort_constructors_first

class CompanyModel {
  final String id;
  final String name;

  CompanyModel({
    required this.id,
    required this.name,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  CompanyModel copyWith({
    String? id,
    String? name,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
