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
  int? zipCode;

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
        city: doc.get("city"),
        streetType: doc.get('streetType'),
        street: doc.get('street'),
        number: doc.get('number'),
        complement: doc.get('complement'),
        district: doc.get('district'),
        zipCode: doc.get('zipCode'));
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'streetType': streetType,
        'street': street,
        'number': number,
        'complement': complement,
        'district': district,
        'zipCode': zipCode
      };
}
