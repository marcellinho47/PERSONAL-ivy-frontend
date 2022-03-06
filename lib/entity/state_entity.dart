import 'package:sys_ivy_frontend/entity/country_entity.dart';

class StateEntity {
  int? idState;
  CountryEntity? country;
  String? name;

  StateEntity({
    this.idState,
    this.country,
    this.name,
  });
}
