import 'package:sys_ivy_frontend/entity/adress_entity.dart';
import 'package:sys_ivy_frontend/entity/adress_type_entity.dart';

class PurchaseAdressEntity {
  int? idPurchaseAdress;
  AdressEntity? adress;
  AdressTypeEntity? adressType;

  PurchaseAdressEntity({
    this.idPurchaseAdress,
    this.adress,
    this.adressType,
  });
}
