import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/product_entity.dart';

class SaleProductsEntity {
  int? idSaleProducts;
  ProductEntity? product;
  int? quantity;
  double? unitaryValue;
  double? discountValue;

  SaleProductsEntity({
    this.idSaleProducts,
    this.product,
    this.quantity,
    this.unitaryValue,
    this.discountValue,
  });

  factory SaleProductsEntity.fromDocument(DocumentSnapshot doc) {
    return SaleProductsEntity(
      idSaleProducts: int.parse(doc.id),
      product: ProductEntity.fromLinkedHashMap(doc.get("product")),
      quantity: doc.get("quantity"),
      unitaryValue: doc.get("unitaryValue"),
      discountValue: doc.get("discountValue"),
    );
  }

  factory SaleProductsEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return SaleProductsEntity(
      idSaleProducts: int.parse(doc['idSaleProducts'].toString()),
      product: ProductEntity.fromLinkedHashMap(doc['product']),
      quantity: doc['quantity'],
      unitaryValue: doc['unitaryValue'],
      discountValue: doc['discountValue'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idSaleProducts': idSaleProducts,
        'product': product?.toJson(),
        'quantity': quantity,
        'unitaryValue': unitaryValue,
        'discountValue': discountValue,
      };
}
