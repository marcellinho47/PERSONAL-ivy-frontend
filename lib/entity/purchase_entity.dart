import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/delivery_type_entity.dart';
import 'package:sys_ivy_frontend/entity/purchase_adress_entity.dart';
import 'package:sys_ivy_frontend/entity/purchase_payment_type_entity.dart';
import 'package:sys_ivy_frontend/entity/purchase_products_entity.dart';

class Purchase {
  int? idPurchase;
  String? store;
  String? site;
  DateTime? purchaseDate;
  DateTime? expectedDeliveryDate;
  DateTime? deliveryDate;
  String? trackingCode;
  DeliveryTypeEntity? deliveryType;
  double? totalValue;
  double? discountValue;
  double? freightValue;
  String? note;
  List<PurchaseAdressEntity?>? listPurchaseAdress;
  List<PurchaseProductsEntity?>? listPurchaseProducts;
  List<PurchasePaymentTypeEntity?>? listPurchasePaymentType;

  Purchase({
    this.idPurchase,
    this.store,
    this.site,
    this.purchaseDate,
    this.expectedDeliveryDate,
    this.deliveryDate,
    this.trackingCode,
    this.deliveryType,
    this.totalValue,
    this.discountValue,
    this.freightValue,
    this.note,
    this.listPurchaseAdress,
    this.listPurchaseProducts,
    this.listPurchasePaymentType,
  });

  factory Purchase.fromDocument(DocumentSnapshot doc) {
    return Purchase(
      idPurchase: int.parse(doc.id),
      store: doc.get("store"),
      site: doc.get("site"),
      purchaseDate: doc.get("purchaseDate"),
      expectedDeliveryDate: doc.get("expectedDeliveryDate"),
      deliveryDate: doc.get("deliveryDate"),
      trackingCode: doc.get("trackingCode"),
      deliveryType:
          DeliveryTypeEntity.fromLinkedHashMap(doc.get("deliveryType")),
      totalValue: doc.get("totalValue"),
      discountValue: doc.get("discountValue"),
      freightValue: doc.get("freightValue"),
      note: doc.get("note"),
      listPurchaseAdress: doc
          .get("listPurchaseAdress")
          .map((e) => PurchaseAdressEntity.fromLinkedHashMap(e))
          .toList(),
      listPurchaseProducts: doc
          .get("listPurchaseProducts")
          .map((e) => PurchaseProductsEntity.fromLinkedHashMap(e))
          .toList(),
      listPurchasePaymentType: doc
          .get("listPurchasePaymentType")
          .map((e) => PurchasePaymentTypeEntity.fromLinkedHashMap(e))
          .toList(),
    );
  }

  factory Purchase.fromLinkedHashMap(LinkedHashMap<String, dynamic> doc) {
    return Purchase(
      idPurchase: int.parse(doc['idPurchase'].toString()),
      store: doc['store'],
      site: doc['site'],
      purchaseDate: doc['purchaseDate'],
      expectedDeliveryDate: doc['expectedDeliveryDate'],
      deliveryDate: doc['deliveryDate'],
      trackingCode: doc['trackingCode'],
      deliveryType: DeliveryTypeEntity.fromLinkedHashMap(doc['deliveryType']),
      totalValue: doc['totalValue'],
      discountValue: doc['discountValue'],
      freightValue: doc['freightValue'],
      note: doc['note'],
      listPurchaseAdress: doc["listPurchaseAdress"]
          .map((e) => PurchaseAdressEntity.fromLinkedHashMap(e))
          .toList(),
      listPurchaseProducts: doc["listPurchaseProducts"]
          .map((e) => PurchaseProductsEntity.fromLinkedHashMap(e))
          .toList(),
      listPurchasePaymentType: doc["listPurchasePaymentType"]
          .map((e) => PurchasePaymentTypeEntity.fromLinkedHashMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'idPurchase': idPurchase,
        'store': store,
        'site': site,
        'purchaseDate': purchaseDate,
        'expectedDeliveryDate': expectedDeliveryDate,
        'deliveryDate': deliveryDate,
        'trackingCode': trackingCode,
        'deliveryType': deliveryType!.toJson(),
        'totalValue': totalValue,
        'discountValue': discountValue,
        'freightValue': freightValue,
        'note': note,
        'listPurchaseAdress':
            listPurchaseAdress?.map((e) => e?.toJson()).toList(),
        'listPurchaseProducts':
            listPurchaseProducts?.map((e) => e?.toJson()).toList(),
        'listPurchasePaymentType':
            listPurchasePaymentType?.map((e) => e?.toJson()).toList(),
      };
}
