import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/category_entity.dart';
import 'package:sys_ivy_frontend/entity/inclusion_exclusion_entity.dart';

class ProductEntity extends InclusionExclusionEntity {
  int? idProduct;
  CategoryEntity? category;
  String? name;
  String? description;
  bool isSelect;
  List<String> images;

  ProductEntity({
    this.idProduct,
    this.category,
    this.name,
    this.description,
    this.isSelect = false,
    this.images = const [],
    idOperatorInclusion,
    inclusionDate,
    idOperatorExclusion,
    exclusionDate,
  }) : super(
          idOperatorInclusion: idOperatorInclusion,
          inclusionDate: inclusionDate,
          idOperatorExclusion: idOperatorExclusion,
          exclusionDate: exclusionDate,
        );

  factory ProductEntity.fromDocument(DocumentSnapshot doc) {
    ProductEntity temp1 = ProductEntity();

    temp1.idProduct = int.parse(doc.id);
    temp1.name = doc.get("name");
    temp1.description = doc.get("description");
    temp1.category = CategoryEntity.fromLinkedHashMap(doc.get("category"));

    temp1.images = doc.get("images").map((e) => e.toString()).toList();

    temp1.idOperatorExclusion = doc.get("idOperatorExclusion");
    temp1.exclusionDate = doc.get("exclusionDate");
    temp1.idOperatorInclusion = doc.get("idOperatorInclusion");
    temp1.inclusionDate = doc.get("inclusionDate");

    return temp1;
  }

  factory ProductEntity.fromLinkedHashMap(LinkedHashMap<String, dynamic> doc) {
    ProductEntity temp1 = ProductEntity();
    temp1.idProduct = int.parse(doc['idProduct'].toString());
    temp1.name = doc['name'];
    temp1.description = doc['description'];
    temp1.category = CategoryEntity.fromLinkedHashMap(doc['category']);

    temp1.images = doc['images'].map((e) => e.toString()).toList();

    temp1.idOperatorExclusion = doc['idOperatorExclusion'];
    temp1.exclusionDate = doc['exclusionDate'];
    temp1.idOperatorInclusion = doc['idOperatorInclusion'];
    temp1.inclusionDate = doc['inclusionDate'];

    return temp1;
  }

  Map<String, dynamic> toJson() => {
        'idProduct': idProduct,
        "category": category!.toJson(),
        "name": name,
        "description": description,
        "images": images,
        'idOperatorInclusion': idOperatorInclusion,
        'inclusionDate': inclusionDate,
        'idOperatorExclusion': idOperatorExclusion,
        'exclusionDate': exclusionDate,
      };
}
