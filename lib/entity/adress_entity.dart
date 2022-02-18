import 'package:sys_ivy_frontend/entity/city_entity.dart';
import 'package:sys_ivy_frontend/entity/street_type_entity.dart';

class AdressEntity {
  int? idAdress;
  CityEntity? city;
  StreetTypeEntity? streetType;
  String? street;
  int? number;
  String? complement;
  String? district;
  int? zipCode;
}
