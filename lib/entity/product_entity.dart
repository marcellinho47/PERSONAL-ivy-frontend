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
      category: CategoryEntity.fromDocument(doc.get("category")),
      name: doc.get("name"),
      description: doc.get("description"),
      images: doc.get("images"),
      idOperatorInclusion: doc.get('idOperatorInclusion'),
      inclusionDate: doc.get('inclusionDate'),
      idOperatorExclusion: doc.get('idOperatorExclusion'),
      exclusionDate: doc.get('exclusionDate'),
    );
  }

  Map<String, dynamic> toJson() => {
        "category": category!.toJson(),
        "name": name,
        "description": description,
        "images": images,
        'idOperatorInclusion': idOperatorInclusion,
        'inclusionDate': inclusionDate,
        'idOperatorExclusion': idOperatorExclusion,
        'exclusionDate': exclusionDate
      };
}
