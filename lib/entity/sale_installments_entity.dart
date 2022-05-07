import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class SaleInstallmentsEntity {
  int? idSaleInstallments;
  int? installments;
  double? value;
  bool isPaid;

  SaleInstallmentsEntity({
    this.idSaleInstallments,
    this.installments,
    this.value,
    this.isPaid = false,
  });

  factory SaleInstallmentsEntity.fromDocument(DocumentSnapshot doc) {
    return SaleInstallmentsEntity(
      idSaleInstallments: int.parse(doc.id),
      installments: doc.get("installments"),
      value: doc.get("value"),
      isPaid: doc.get("isPaid"),
    );
  }

  factory SaleInstallmentsEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return SaleInstallmentsEntity(
      idSaleInstallments: int.parse(doc['idSaleInstallments'].toString()),
      installments: doc['installments'],
      value: doc['value'],
      isPaid: doc['isPaid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idSaleInstallments': idSaleInstallments,
        'installments': installments,
        'value': value,
        'isPaid': isPaid,
      };
}
