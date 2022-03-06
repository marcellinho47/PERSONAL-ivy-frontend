import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryTypeEntity {
  int? idDeliveryType;
  String? description;

  DeliveryTypeEntity({
    this.idDeliveryType,
    this.description,
  });

  factory DeliveryTypeEntity.fromDocument(DocumentSnapshot doc) {
    return DeliveryTypeEntity(
        idDeliveryType: int.parse(doc.id), description: doc.get("description"));
  }

  Map<String, dynamic> toJson() => {'description': description};
}
