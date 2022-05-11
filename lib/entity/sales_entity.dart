import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/delivery_type_entity.dart';
import 'package:sys_ivy_frontend/entity/person_entity.dart';
import 'package:sys_ivy_frontend/entity/sale_adress_entity.dart';
import 'package:sys_ivy_frontend/entity/sale_payment_type_entity.dart';
import 'package:sys_ivy_frontend/entity/sale_products_entity.dart';

class SaleEntity {
  int? idSaleEntity;
  PersonEntity? clientPerson;
  DateTime? saleDate;
  DateTime? expectedDeliveryDate;
  DateTime? deliveryDate;
  String? trackingCode;
  DeliveryTypeEntity? deliveryType;
  int? warrantyDays;
  double? productsValue;
  double? totalValue;
  double? freightValue;
  double? discountValue;
  String? note;
  List<SaleProductsEntity?>? listSaleProducts;
  List<SalePaymentTypeEntity?>? listSalePaymentType;
  List<SaleAdressEntity?>? listSaleAdress;

  SaleEntity({
    this.idSaleEntity,
    this.clientPerson,
    this.saleDate,
    this.expectedDeliveryDate,
    this.deliveryDate,
    this.trackingCode,
    this.deliveryType,
    this.warrantyDays,
    this.productsValue,
    this.totalValue,
    this.freightValue,
    this.discountValue,
    this.note,
    this.listSaleProducts,
    this.listSalePaymentType,
    this.listSaleAdress,
  });

  factory SaleEntity.fromDocument(DocumentSnapshot doc) {
    return SaleEntity(
      idSaleEntity: int.parse(doc.id),
      clientPerson: PersonEntity.fromLinkedHashMap(doc.get("clientPerson")),
      saleDate: doc.get("saleDate"),
      expectedDeliveryDate: doc.get("expectedDeliveryDate"),
      deliveryDate: doc.get("deliveryDate"),
      trackingCode: doc.get("trackingCode"),
      deliveryType:
          DeliveryTypeEntity.fromLinkedHashMap(doc.get("deliveryType")),
      warrantyDays: doc.get("warrantyDays"),
      productsValue: doc.get("productsValue"),
      totalValue: doc.get("totalValue"),
      freightValue: doc.get("freightValue"),
      discountValue: doc.get("discountValue"),
      note: doc.get("note"),
      listSaleProducts: doc
          .get("listSaleProducts")
          .map((e) => SaleProductsEntity.fromLinkedHashMap(e))
          .toList(),
      listSalePaymentType: doc
          .get("listSalePaymentType")
          .map((e) => SalePaymentTypeEntity.fromLinkedHashMap(e))
          .toList(),
      listSaleAdress: doc
          .get("listSaleAdress")
          .map((e) => SaleAdressEntity.fromLinkedHashMap(e))
          .toList(),
    );
  }

  factory SaleEntity.fromLinkedHashMap(Map<String, dynamic> map) {
    return SaleEntity(
      idSaleEntity: map["idSaleEntity"],
      clientPerson: PersonEntity.fromLinkedHashMap(map["clientPerson"]),
      saleDate: map["saleDate"],
      expectedDeliveryDate: map["expectedDeliveryDate"],
      deliveryDate: map["deliveryDate"],
      trackingCode: map["trackingCode"],
      deliveryType: DeliveryTypeEntity.fromLinkedHashMap(map["deliveryType"]),
      warrantyDays: map["warrantyDays"],
      productsValue: map["productsValue"],
      totalValue: map["totalValue"],
      freightValue: map["freightValue"],
      discountValue: map["discountValue"],
      note: map["note"],
      listSaleProducts: map["listSaleProducts"]
          .map((e) => SaleProductsEntity.fromLinkedHashMap(e))
          .toList(),
      listSalePaymentType: map["listSalePaymentType"]
          .map((e) => SalePaymentTypeEntity.fromLinkedHashMap(e))
          .toList(),
      listSaleAdress: map["listSaleAdress"]
          .map((e) => SaleAdressEntity.fromLinkedHashMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "idSaleEntity": idSaleEntity,
        "clientPerson": clientPerson?.toJson(),
        "saleDate": saleDate,
        "expectedDeliveryDate": expectedDeliveryDate,
        "deliveryDate": deliveryDate,
        "trackingCode": trackingCode,
        "deliveryType": deliveryType?.toJson(),
        "warrantyDays": warrantyDays,
        "productsValue": productsValue,
        "totalValue": totalValue,
        "freightValue": freightValue,
        "discountValue": discountValue,
        "note": note,
        "listSaleProducts": listSaleProducts?.map((e) => e?.toJson()).toList(),
        "listSalePaymentType":
            listSalePaymentType?.map((e) => e?.toJson()).toList(),
        "listSaleAdress": listSaleAdress?.map((e) => e?.toJson()).toList(),
      };
}
