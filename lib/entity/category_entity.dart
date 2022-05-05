import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryEntity {
  int? idCategory;
  String? description;
  bool? enabled;
  bool isSelect;

  CategoryEntity({
    this.idCategory,
    this.description,
    this.enabled,
    this.isSelect = false,
  });

  factory CategoryEntity.fromDocument(DocumentSnapshot doc) {
    return CategoryEntity(
      idCategory: int.parse(doc.id),
      description: doc.get("description"),
      enabled: doc.get('enabled'),
    );
  }

  factory CategoryEntity.fromLinkedHashMap(LinkedHashMap<String, dynamic> doc) {
    return CategoryEntity(
      idCategory: int.parse(doc['idCategory'].toString()),
      description: doc['description'],
      enabled: doc['enabled'],
    );
  }

  Map<String, dynamic> toJson() => {
        'description': description,
        'enabled': enabled,
        'idCategory': idCategory,
      };
}
