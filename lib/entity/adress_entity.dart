import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/city_entity.dart';
import 'package:sys_ivy_frontend/entity/street_type_entity.dart';

class AdressEntity {
  int? idAdress;
  CityEntity? city;
  StreetTypeEntity? streetType;
  String? street;
  int? number;
  String? complement;
  String? district;
  String? zipCode;

  AdressEntity({
    this.idAdress,
    this.city,
    this.streetType,
    this.street,
    this.number,
    this.complement,
    this.district,
    this.zipCode,
  });

  factory AdressEntity.fromDocument(DocumentSnapshot doc) {
    return AdressEntity(
      idAdress: int.parse(doc.id),
      city: CityEntity.fromLinkedHashMap(doc.get("city")),
      streetType: StreetTypeEntity.fromLinkedHashMap(doc.get('streetType')),
      street: doc.get('street'),
      number: doc.get('number'),
      complement: doc.get('complement'),
      district: doc.get('district'),
      zipCode: doc.get('zipCode'),
    );
  }

  factory AdressEntity.fromLinkedHashMap(LinkedHashMap<String, dynamic> doc) {
    return AdressEntity(
      idAdress: int.parse(doc['idAdress'].toString()),
      city: CityEntity.fromLinkedHashMap(doc['city']),
      streetType: StreetTypeEntity.fromLinkedHashMap(doc['streetType']),
      street: doc['street'],
      number: doc['number'],
      complement: doc['complement'],
      district: doc['district'],
      zipCode: doc['zipCode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idAdress': idAdress,
        'city': city?.toJson(),
        'streetType': streetType?.toJson(),
        'street': street,
        'number': number,
        'complement': complement,
        'district': district,
        'zipCode': zipCode
      };
}
