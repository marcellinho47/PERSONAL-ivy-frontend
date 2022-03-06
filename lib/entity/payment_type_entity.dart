import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentTypeEntity {
  int? idPaymentType;
  String? description;

  PaymentTypeEntity({this.idPaymentType, this.description});

  factory PaymentTypeEntity.fromDocument(DocumentSnapshot doc) {
    return PaymentTypeEntity(
        idPaymentType: int.parse(doc.id), description: doc.get("description"));
  }

  Map<String, dynamic> toJson() => {'description': description};
}
