import 'dart:collection';

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
      idDeliveryType: int.parse(doc.id),
      description: doc.get("description"),
    );
  }

  factory DeliveryTypeEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return DeliveryTypeEntity(
      idDeliveryType: int.parse(doc['idDeliveryType'].toString()),
      description: doc['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idDeliveryType': idDeliveryType,
        'description': description,
      };
}
