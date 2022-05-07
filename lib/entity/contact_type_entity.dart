import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class ContactTypeEntity {
  int? idContactType;
  String? description;

  ContactTypeEntity({
    this.idContactType,
    this.description,
  });

  factory ContactTypeEntity.fromDocument(DocumentSnapshot doc) {
    return ContactTypeEntity(
      idContactType: int.parse(doc.id),
      description: doc.get("description"),
    );
  }

  factory ContactTypeEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return ContactTypeEntity(
      idContactType: int.parse(doc['idContactType'].toString()),
      description: doc['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idContactType': idContactType,
        'description': description,
      };
}
