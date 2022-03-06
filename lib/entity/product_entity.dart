import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/category_entity.dart';

class ProductEntity {
  int? idProduct;
  CategoryEntity? category;
  String? name;
  String? description;

  ProductEntity({
    this.idProduct,
    this.category,
    this.name,
    this.description,
  });

  factory ProductEntity.fromDocument(DocumentSnapshot doc) {
    return ProductEntity(
      idProduct: int.parse(doc.id),
      category: CategoryEntity.fromDocument(doc.get("adress")),
      name: doc.get("name"),
      description: doc.get("description"),
    );
  }

  Map<String, dynamic> toJson() => {
        "category": category!.toJson(),
        "name": name,
        'description': description
      };
}
