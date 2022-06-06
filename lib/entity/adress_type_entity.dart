import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class AdressTypeEntity {
  int? idAdressType;
  String? description;

  AdressTypeEntity({
    this.idAdressType,
    this.description,
  });

  factory AdressTypeEntity.fromDocument(DocumentSnapshot doc) {
    return AdressTypeEntity(
      idAdressType: int.parse(doc.id),
      description: doc.get("description"),
    );
  }

  factory AdressTypeEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return AdressTypeEntity(
      idAdressType: int.parse(doc['idAdressType'].toString()),
      description: doc['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idAdressType': idAdressType,
        'description': description,
      };
}
