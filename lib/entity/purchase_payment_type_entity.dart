import 'package:sys_ivy_frontend/entity/payment_type_entity.dart';
import 'package:sys_ivy_frontend/entity/purchase_installments_entity.dart';

class PurchasePaymentTypeEntity {
  int? idPurchasePaymentType;
  PaymentTypeEntity? paymentType;
  double? totalValue;
  double? paidValue;
  int? totalInstallments;
  List<PurchaseInstallmentsEntity?>? listPurchaseInstallments;
}
