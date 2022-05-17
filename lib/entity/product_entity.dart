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
    return ProductEntity(
      idProduct: int.parse(doc.id),
      name: doc.get("name"),
      description: doc.get("description"),
      category: CategoryEntity.fromLinkedHashMap(doc.get("category")),
      images: (doc.get("images") as List<dynamic>).isEmpty
          ? []
          : doc.get("images").map((e) => e.toString()).toList(),
      idOperatorExclusion: doc.get("idOperatorExclusion"),
      exclusionDate: doc.get("exclusionDate"),
      idOperatorInclusion: doc.get("idOperatorInclusion"),
      inclusionDate: doc.get("inclusionDate"),
    );
  }

  factory ProductEntity.fromLinkedHashMap(LinkedHashMap<String, dynamic> doc) {
    return ProductEntity(
      idProduct: int.parse(doc['idProduct'].toString()),
      name: doc['name'],
      description: doc['description'],
      category: CategoryEntity.fromLinkedHashMap(doc['category']),
      images: doc['images'].map((e) => e.toString()).toList(),
      idOperatorExclusion: doc['idOperatorExclusion'],
      exclusionDate: doc['exclusionDate'],
      idOperatorInclusion: doc['idOperatorInclusion'],
      inclusionDate: doc['inclusionDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idProduct': idProduct,
        "category": category?.toJson(),
        "name": name,
        "description": description,
        "images": images,
        'idOperatorInclusion': idOperatorInclusion,
        'inclusionDate': inclusionDate,
        'idOperatorExclusion': idOperatorExclusion,
        'exclusionDate': exclusionDate,
      };
}
