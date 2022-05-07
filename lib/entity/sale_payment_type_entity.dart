import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/payment_type_entity.dart';
import 'package:sys_ivy_frontend/entity/sale_installments_entity.dart';

class SalePaymentTypeEntity {
  int? idSalePaymentType;
  PaymentTypeEntity? paymentType;
  double? totalValue;
  double? paidValue;
  int? totalInstallments;
  List<SaleInstallmentsEntity?>? listSaleInstallments;

  SalePaymentTypeEntity({
    this.idSalePaymentType,
    this.paymentType,
    this.totalValue,
    this.paidValue,
    this.totalInstallments,
    this.listSaleInstallments,
  });

  factory SalePaymentTypeEntity.fromDocument(DocumentSnapshot doc) {
    return SalePaymentTypeEntity(
      idSalePaymentType: int.parse(doc.id),
      paymentType: PaymentTypeEntity.fromLinkedHashMap(doc.get("paymentType")),
      totalValue: doc.get("totalValue"),
      paidValue: doc.get("paidValue"),
      totalInstallments: doc.get("totalInstallments"),
      listSaleInstallments: doc
          .get("listSaleInstallments")
          .map((e) => SaleInstallmentsEntity.fromLinkedHashMap(e))
          .toList(),
    );
  }

  factory SalePaymentTypeEntity.fromLinkedHashMap(
      LinkedHashMap<String, dynamic> doc) {
    return SalePaymentTypeEntity(
      idSalePaymentType: int.parse(doc['idSalePaymentType'].toString()),
      paymentType: PaymentTypeEntity.fromLinkedHashMap(doc['paymentType']),
      totalValue: doc['totalValue'],
      paidValue: doc['paidValue'],
      totalInstallments: doc['totalInstallments'],
      listSaleInstallments: doc['listSaleInstallments']
          .map((e) => SaleInstallmentsEntity.fromLinkedHashMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'idSalePaymentType': idSalePaymentType,
        'paymentType': paymentType!.toJson(),
        'totalValue': totalValue,
        'paidValue': paidValue,
        'totalInstallments': totalInstallments,
        'listSaleInstallments':
            listSaleInstallments?.map((e) => e!.toJson()).toList(),
      };
}
