import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class StreetTypeEntity {
  int? idStreetType;
  String? description;
  String? nick;

  StreetTypeEntity({
    this.idStreetType,
    this.description,
    this.nick,
  });

  factory StreetTypeEntity.fromDocument(DocumentSnapshot doc) {
    return StreetTypeEntity(
        idStreetType: int.parse(doc.id),
        description: doc.get('description'),
        nick: doc.get('nick'));
  }

  factory StreetTypeEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return StreetTypeEntity(
        idStreetType: int.parse(doc['idStreetType'].toString()),
        description: doc['description'],
        nick: doc['nick']);
  }

  Map<String, dynamic> toJson() => {
        'idStreetType': idStreetType,
        'description': description,
        'nick': nick,
      };
}
