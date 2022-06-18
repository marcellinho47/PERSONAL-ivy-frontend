import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/street_type_entity.dart';

class AdressEntity {
  int? idAdress;
  StreetTypeEntity? streetType;
  String? street;
  int? number;
  String? complement;
  String? district;
  String? zipCode;
  int? idCity;
  String? state;
  int? country;

  AdressEntity({
    this.idAdress,
    this.streetType,
    this.street,
    this.number,
    this.complement,
    this.district,
    this.zipCode,
    this.idCity,
    this.state,
    this.country,
  });

  factory AdressEntity.fromDocument(DocumentSnapshot doc) {
    return AdressEntity(
      idAdress: int.parse(doc.id),
      streetType: StreetTypeEntity.fromLinkedHashMap(doc.get('streetType')),
      street: doc.get('street'),
      number: doc.get('number'),
      complement: doc.get('complement'),
      district: doc.get('district'),
      zipCode: doc.get('zipCode'),
      idCity: doc.get('city'),
      state: doc.get('state'),
      country: doc.get('country'),
    );
  }

  factory AdressEntity.fromLinkedHashMap(LinkedHashMap<String, dynamic> doc) {
    return AdressEntity(
      idAdress: int.parse(doc['idAdress'].toString()),
      streetType: StreetTypeEntity.fromLinkedHashMap(doc['streetType']),
      street: doc['street'],
      number: doc['number'],
      complement: doc['complement'],
      district: doc['district'],
      zipCode: doc['zipCode'],
      idCity: doc['city'],
      state: doc['state'],
      country: doc['country'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idAdress': idAdress,
        'streetType': streetType?.toJson(),
        'street': street,
        'number': number,
        'complement': complement,
        'district': district,
        'zipCode': zipCode,
        'city': idCity,
        'state': state,
        'country': country,
      };
}
