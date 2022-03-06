import 'package:sys_ivy_frontend/entity/adress_entity.dart';
import 'package:sys_ivy_frontend/entity/adress_type_entity.dart';

class SaleAdressEntity {
  int? idSaleAdress;
  AdressEntity? adress;
  AdressTypeEntity? adressType;

  SaleAdressEntity({
    this.idSaleAdress,
    this.adress,
    this.adressType,
  });
}
