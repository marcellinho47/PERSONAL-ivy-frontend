import 'package:sys_ivy_frontend/entity/product_entity.dart';

class PurchaseProductsEntity {
  int? idPurchaseProducts;
  ProductEntity? product;
  int? quantity;
  double? unitaryValue;
  double? discountValue;

  PurchaseProductsEntity({
    this.idPurchaseProducts,
    this.product,
    this.quantity,
    this.unitaryValue,
    this.discountValue,
  });
}
