import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/adress_entity.dart';
import 'package:sys_ivy_frontend/entity/adress_type_entity.dart';

class SaleAdressEntity {
  int? idSaleAdress;
  AdressEntity? adress;
  AdressTypeEntity? adressType;

  SaleAdressEntity({
    this.idSaleAdress,
    this.adress,
    this.adressType,
  });

  factory SaleAdressEntity.fromDocument(DocumentSnapshot doc) {
    return SaleAdressEntity(
      idSaleAdress: int.parse(doc.id),
      adress: AdressEntity.fromLinkedHashMap(doc.get("adress")),
      adressType: AdressTypeEntity.fromLinkedHashMap(doc.get("adressType")),
    );
  }

  factory SaleAdressEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return SaleAdressEntity(
      idSaleAdress: int.parse(doc['idSaleAdress'].toString()),
      adress: AdressEntity.fromLinkedHashMap(doc['adress']),
      adressType: AdressTypeEntity.fromLinkedHashMap(doc['adressType']),
    );
  }

  Map<String, dynamic> toJson() => {
        'idSaleAdress': idSaleAdress,
        'adress': adress!.toJson(),
        "adressType": adressType!.toJson(),
      };
}
