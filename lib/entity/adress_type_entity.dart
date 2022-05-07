import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class AdressTypeEntity {
  int? idAdressTypeEntity;
  String? description;

  AdressTypeEntity({
    this.idAdressTypeEntity,
    this.description,
  });

  factory AdressTypeEntity.fromDocument(DocumentSnapshot doc) {
    return AdressTypeEntity(
      idAdressTypeEntity: int.parse(doc.id),
      description: doc.get("description"),
    );
  }

  factory AdressTypeEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return AdressTypeEntity(
      idAdressTypeEntity: int.parse(doc['idAdressTypeEntity'].toString()),
      description: doc['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idAdressTypeEntity': idAdressTypeEntity,
        'description': description,
      };
}
