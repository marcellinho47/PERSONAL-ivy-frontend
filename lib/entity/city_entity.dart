import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class CityEntity {
  int? idCity;
  String? name;
  String? state;
  String? country;

  CityEntity({
    this.idCity,
    this.name,
    this.state,
    this.country,
  }); 

  factory CityEntity.fromDocument(DocumentSnapshot doc) {
    return CityEntity(
      idCity: int.parse(doc.id),
      name: doc.get('name'),
      state: doc.get('state'),
      country: doc.get('country'),
    );
  }

  factory CityEntity.fromLinkedHashMap(LinkedHashMap<String, dynamic> doc) {
    return CityEntity(
      idCity: int.parse(doc['idCity'].toString()),
      name: doc['name'],
      state: doc['state'],
      country: doc['country'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idCity': idCity,
        'name': name,
        'state': state,
        'country': country,
      };
}
