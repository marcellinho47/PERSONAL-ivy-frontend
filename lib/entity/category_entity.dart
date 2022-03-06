import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryEntity {
  int? idCategory;
  String? description;
  bool? enabled;
  bool isSelect;

  CategoryEntity(
      {this.idCategory, this.description, this.enabled, this.isSelect = false});

  factory CategoryEntity.fromDocument(DocumentSnapshot doc) {
    return CategoryEntity(
      idCategory: int.parse(doc.id),
      description: doc.get("description"),
      enabled: doc.get('enabled'),
    );
  }

  Map<String, dynamic> toJson() => {
        'description': description,
        'enabled': enabled,
      };
}
