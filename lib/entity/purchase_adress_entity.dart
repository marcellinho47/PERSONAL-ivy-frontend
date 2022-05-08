import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/adress_entity.dart';
import 'package:sys_ivy_frontend/entity/adress_type_entity.dart';

class PurchaseAdressEntity {
  int? idPurchaseAdress;
  AdressEntity? adress;
  AdressTypeEntity? adressType;

  PurchaseAdressEntity({
    this.idPurchaseAdress,
    this.adress,
    this.adressType,
  });

  factory PurchaseAdressEntity.fromDocument(DocumentSnapshot doc) {
    return PurchaseAdressEntity(
      idPurchaseAdress: int.parse(doc.id),
      adress: AdressEntity.fromLinkedHashMap(doc.get("adress")),
      adressType: AdressTypeEntity.fromLinkedHashMap(doc.get("adressType")),
    );
  }

  factory PurchaseAdressEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return PurchaseAdressEntity(
      idPurchaseAdress: int.parse(doc['idPurchaseAdress'].toString()),
      adress: AdressEntity.fromLinkedHashMap(doc['adress']),
      adressType: AdressTypeEntity.fromLinkedHashMap(doc['adressType']),
    );
  }

  Map<String, dynamic> toJson() => {
        'idPurchaseAdress': idPurchaseAdress,
        'adress': adress?.toJson(),
        "adressType": adressType?.toJson(),
      };
}
