import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class StreetTypeEntity {
  int? idStreetType;
  String? description;

  StreetTypeEntity({
    this.idStreetType,
    this.description,
  });

  factory StreetTypeEntity.fromDocument(DocumentSnapshot doc) {
    return StreetTypeEntity(
      idStreetType: int.parse(doc.id),
      description: doc.get('description'),
    );
  }

  factory StreetTypeEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return StreetTypeEntity(
      idStreetType: int.parse(doc['idStreetType'].toString()),
      description: doc['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idStreetType': idStreetType,
        'description': description,
      };
}
