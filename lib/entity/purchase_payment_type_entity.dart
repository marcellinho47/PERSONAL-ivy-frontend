import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/payment_type_entity.dart';
import 'package:sys_ivy_frontend/entity/purchase_installments_entity.dart';

class PurchasePaymentTypeEntity {
  int? idPurchasePaymentType;
  PaymentTypeEntity? paymentType;
  double? totalValue;
  double? paidValue;
  int? totalInstallments;
  List<PurchaseInstallmentsEntity?>? listPurchaseInstallments;

  PurchasePaymentTypeEntity({
    this.idPurchasePaymentType,
    this.paymentType,
    this.totalValue,
    this.paidValue,
    this.totalInstallments,
    this.listPurchaseInstallments,
  });

  factory PurchasePaymentTypeEntity.fromDocument(DocumentSnapshot doc) {
    return PurchasePaymentTypeEntity(
      idPurchasePaymentType: int.parse(doc.id),
      paymentType: PaymentTypeEntity.fromLinkedHashMap(doc.get("paymentType")),
      totalValue: doc.get("totalValue"),
      paidValue: doc.get("paidValue"),
      totalInstallments: doc.get("totalInstallments"),
      listPurchaseInstallments: doc
          .get("listPurchaseInstallments")
          .map((e) => PurchaseInstallmentsEntity.fromLinkedHashMap(e))
          .toList(),
    );
  }

  factory PurchasePaymentTypeEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return PurchasePaymentTypeEntity(
      idPurchasePaymentType: int.parse(doc['idPurchasePaymentType'].toString()),
      paymentType: PaymentTypeEntity.fromLinkedHashMap(doc['paymentType']),
      totalValue: doc['totalValue'],
      paidValue: doc['paidValue'],
      totalInstallments: doc['totalInstallments'],
      listPurchaseInstallments: doc['listPurchaseInstallments']
          .map((e) => PurchaseInstallmentsEntity.fromLinkedHashMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'idPurchasePaymentType': idPurchasePaymentType,
        'paymentType': paymentType!.toJson(),
        'totalValue': totalValue,
        'paidValue': paidValue,
        'totalInstallments': totalInstallments,
        'listPurchaseInstallments':
            listPurchaseInstallments?.map((e) => e?.toJson()).toList(),
      };
}
