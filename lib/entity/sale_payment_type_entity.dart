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
}
