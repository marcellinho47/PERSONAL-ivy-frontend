import 'package:sys_ivy_frontend/entity/delivery_type_entity.dart';
import 'package:sys_ivy_frontend/entity/person_entity.dart';
import 'package:sys_ivy_frontend/entity/sale_adress_entity.dart';
import 'package:sys_ivy_frontend/entity/sale_payment_type_entity.dart';
import 'package:sys_ivy_frontend/entity/sale_products_entity.dart';

class SaleEntity {
  int? idSaleEntity;
  PersonEntity? clientPerson;
  DateTime? saleDate;
  DateTime? expectedDeliveryDate;
  DateTime? deliveryDate;
  String? trackingCode;
  DeliveryTypeEntity? deliveryType;
  int? warrantyDays;
  double? productsValue;
  double? totalValue;
  double? freightValue;
  double? discountValue;
  String? note;
  List<SaleProductsEntity?>? listSaleProducts;
  List<SalePaymentTypeEntity?>? listSalePaymentType;
  List<SaleAdressEntity?>? listSaleAdress;

  SaleEntity({
    this.idSaleEntity,
    this.clientPerson,
    this.saleDate,
    this.expectedDeliveryDate,
    this.deliveryDate,
    this.trackingCode,
    this.deliveryType,
    this.warrantyDays,
    this.productsValue,
    this.totalValue,
    this.freightValue,
    this.discountValue,
    this.note,
    this.listSaleProducts,
    this.listSalePaymentType,
    this.listSaleAdress,
  });
}
