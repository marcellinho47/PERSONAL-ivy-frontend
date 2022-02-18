import 'package:sys_ivy_frontend/entity/delivery_type_entity.dart';
import 'package:sys_ivy_frontend/entity/purchase_adress_entity.dart';
import 'package:sys_ivy_frontend/entity/purchase_payment_type_entity.dart';
import 'package:sys_ivy_frontend/entity/purchase_products_entity.dart';

class Purchase {
  int? idPurchase;
  String? store;
  String? site;
  DateTime? purchaseDate;
  DateTime? expectedDeliveryDate;
  DateTime? deliveryDate;
  String? trackingCode;
  DeliveryTypeEntity? deliveryType;
  double? totalValue;
  double? discountValue;
  double? freightValue;
  String? note;
  List<PurchaseAdressEntity?>? listPurchaseAdress;
  List<PurchaseProductsEntity?>? listPurchaseProducts;
  List<PurchasePaymentTypeEntity?>? listPurchasePaymentType;
}
