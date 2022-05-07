import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/adress_entity.dart';
import 'package:sys_ivy_frontend/entity/adress_type_entity.dart';

class PersonAdressEntity {
  int? idPersonAdress;
  AdressEntity? adress;
  AdressTypeEntity? adressType;

  PersonAdressEntity({
    this.idPersonAdress,
    this.adress,
    this.adressType,
  });

  factory PersonAdressEntity.fromDocument(DocumentSnapshot doc) {
    return PersonAdressEntity(
      idPersonAdress: int.parse(doc.id),
      adress: AdressEntity.fromLinkedHashMap(doc.get("adress")),
      adressType: AdressTypeEntity.fromLinkedHashMap(doc.get("adressType")),
    );
  }

  factory PersonAdressEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return PersonAdressEntity(
      idPersonAdress: int.parse(doc['idPersonAdress'].toString()),
      adress: AdressEntity.fromLinkedHashMap(doc['adress']),
      adressType: AdressTypeEntity.fromLinkedHashMap(doc['adressType']),
    );
  }

  Map<String, dynamic> toJson() => {
        'idPersonAdress': idPersonAdress,
        'adress': adress!.toJson(),
        "adressType": adressType!.toJson(),
      };
}
