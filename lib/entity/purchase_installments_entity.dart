import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseInstallmentsEntity {
  int? idPurchaseInstallments;
  int? installments;
  double? value;
  bool isPaid;

  PurchaseInstallmentsEntity({
    this.idPurchaseInstallments,
    this.installments,
    this.value,
    this.isPaid = false,
  });

  factory PurchaseInstallmentsEntity.fromDocument(DocumentSnapshot doc) {
    return PurchaseInstallmentsEntity(
      idPurchaseInstallments: int.parse(doc.id),
      installments: doc.get("installments"),
      value: doc.get("value"),
      isPaid: doc.get("isPaid"),
    );
  }

  factory PurchaseInstallmentsEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return PurchaseInstallmentsEntity(
      idPurchaseInstallments:
          int.parse(doc['idPurchaseInstallments'].toString()),
      installments: doc['installments'],
      value: doc['value'],
      isPaid: doc['isPaid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idPurchaseInstallments': idPurchaseInstallments,
        'installments': installments,
        'value': value,
        'isPaid': isPaid,
      };
}
