import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/product_entity.dart';

class PurchaseProductsEntity {
  int? idPurchaseProducts;
  ProductEntity? product;
  int? quantity;
  double? unitaryValue;
  double? discountValue;

  PurchaseProductsEntity({
    this.idPurchaseProducts,
    this.product,
    this.quantity,
    this.unitaryValue,
    this.discountValue,
  });

  factory PurchaseProductsEntity.fromDocument(DocumentSnapshot doc) {
    return PurchaseProductsEntity(
      idPurchaseProducts: int.parse(doc.id),
      product: ProductEntity.fromLinkedHashMap(doc.get("product")),
      quantity: doc.get("quantity"),
      unitaryValue: doc.get("unitaryValue"),
      discountValue: doc.get("discountValue"),
    );
  }

  factory PurchaseProductsEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return PurchaseProductsEntity(
      idPurchaseProducts: int.parse(doc['idPurchaseProducts'].toString()),
      product: ProductEntity.fromLinkedHashMap(doc['product']),
      quantity: doc['quantity'],
      unitaryValue: doc['unitaryValue'],
      discountValue: doc['discountValue'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idPurchaseProducts': idPurchaseProducts,
        'product': product?.toJson(),
        'quantity': quantity,
        'unitaryValue': unitaryValue,
        'discountValue': discountValue,
      };
}
