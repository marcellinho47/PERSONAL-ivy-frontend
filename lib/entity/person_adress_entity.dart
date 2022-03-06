import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/adress_entity.dart';
import 'package:sys_ivy_frontend/entity/adress_type_entity.dart';

class PersonAdressEntity {
  int? idPersonAdress;
  AdressEntity? adress;
  AdressTypeEntity? adressType;

  PersonAdressEntity({
    this.idPersonAdress,
    this.adress,
    this.adressType,
  });

  factory PersonAdressEntity.fromDocument(DocumentSnapshot doc) {
    return PersonAdressEntity(
        idPersonAdress: int.parse(doc.id),
        adress: AdressEntity.fromDocument(doc.get("adress")),
        adressType: AdressTypeEntity.fromDocument(doc.get("adressType")));
  }

  Map<String, dynamic> toJson() =>
      {'adress': adress!.toJson(), "adressType": adressType!.toJson()};
}
