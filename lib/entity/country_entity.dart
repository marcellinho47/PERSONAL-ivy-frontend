import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class CountryEntity {
  int? idCountry;
  String? name;

  CountryEntity({
    this.idCountry,
    this.name,
  });

  factory CountryEntity.fromDocument(DocumentSnapshot doc) {
    return CountryEntity(
      idCountry: int.parse(doc.id),
      name: doc.get("name"),
    );
  }

  factory CountryEntity.fromLinkedHashMap(LinkedHashMap<String, dynamic> doc) {
    return CountryEntity(
      idCountry: int.parse(doc['idCountry'].toString()),
      name: doc['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idCountry': idCountry,
        'name': name,
      };
}
