import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/country_entity.dart';

class StateEntity {
  int? idState;
  CountryEntity? country;
  String? name;

  StateEntity({
    this.idState,
    this.country,
    this.name,
  });

  factory StateEntity.fromDocument(DocumentSnapshot doc) {
    return StateEntity(
      idState: int.parse(doc.id),
      country: CountryEntity.fromLinkedHashMap(doc.get("country")),
      name: doc.get("name"),
    );
  }

  factory StateEntity.fromLinkedHashMap(LinkedHashMap<String, dynamic> doc) {
    return StateEntity(
      idState: int.parse(doc['idState'].toString()),
      country: CountryEntity.fromLinkedHashMap(doc['country']),
      name: doc['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idState': idState,
        'country': country!.toJson(),
        'name': name,
      };
}
