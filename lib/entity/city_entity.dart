import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/state_entity.dart';

class CityEntity {
  int? idCity;
  int? idIBGE;
  String? name;
  StateEntity? state;

  CityEntity({
    this.idCity,
    this.idIBGE,
    this.name,
    this.state,
  });

  factory CityEntity.fromDocument(DocumentSnapshot doc) {
    return CityEntity(
      idCity: int.parse(doc.id),
      idIBGE: doc.get("idIBGE"),
      name: doc.get("name"),
      state: StateEntity.fromLinkedHashMap(doc.get("state")),
    );
  }

  factory CityEntity.fromLinkedHashMap(LinkedHashMap<String, dynamic> doc) {
    return CityEntity(
      idCity: int.parse(doc['idCity'].toString()),
      idIBGE: doc['idIBGE'],
      name: doc['name'],
      state: StateEntity.fromLinkedHashMap(doc['state']),
    );
  }

  Map<String, dynamic> toJson() => {
        'idCity': idCity,
        'idIBGE': idIBGE,
        'name': name,
        'state': state!.toJson(),
      };
}
