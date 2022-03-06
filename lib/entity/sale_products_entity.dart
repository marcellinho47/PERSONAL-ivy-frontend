import 'package:sys_ivy_frontend/entity/product_entity.dart';

class SaleProductsEntity {
  int? idSaleProducts;
  ProductEntity? product;
  int? quantity;
  double? unitaryValue;
  double? discountValue;

  SaleProductsEntity({
    this.idSaleProducts,
    this.product,
    this.quantity,
    this.unitaryValue,
    this.discountValue,
  });
}
