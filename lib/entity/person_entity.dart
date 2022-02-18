import 'package:sys_ivy_frontend/entity/contact_entity.dart';
import 'package:sys_ivy_frontend/entity/person_adress_entity.dart';

class PersonEntity {
  int? idPerson;
  String? name;
  int? personType;
  String? cpf;
  String? cnpj;
  int? sex;
  DateTime? birthday;
  List<ContactEntity?>? listConcact;
  List<PersonAdressEntity?>? listPersonAdress;
}
