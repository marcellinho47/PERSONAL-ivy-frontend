import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/contact_type_entity.dart';

class ContactEntity {
  int? idContact;
  ContactTypeEntity? contactType;
  String? description;

  ContactEntity({
    this.idContact,
    this.contactType,
    this.description,
  });

  factory ContactEntity.fromDocument(DocumentSnapshot doc) {
    return ContactEntity(
      idContact: int.parse(doc.id),
      contactType: ContactTypeEntity.fromLinkedHashMap(doc.get("contactType")),
      description: doc.get("description"),
    );
  }

  factory ContactEntity.fromLinkedHashMap(LinkedHashMap<String, dynamic> doc) {
    return ContactEntity(
      idContact: int.parse(doc['idContact'].toString()),
      contactType: ContactTypeEntity.fromLinkedHashMap(doc['contactType']),
      description: doc['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idContact': idContact,
        'contactType': contactType?.toJson(),
        'description': description,
      };
}
