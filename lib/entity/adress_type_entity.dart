import 'package:cloud_firestore/cloud_firestore.dart';

class AdressTypeEntity {
  int? idAdressTypeEntity;
  String? description;

  AdressTypeEntity({
    this.idAdressTypeEntity,
    this.description,
  });

  factory AdressTypeEntity.fromDocument(DocumentSnapshot doc) {
    return AdressTypeEntity(
        idAdressTypeEntity: int.parse(doc.id),
        description: doc.get("description"));
  }

  Map<String, dynamic> toJson() => {'description': description};
}
