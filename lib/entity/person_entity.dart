import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/contact_entity.dart';
import 'package:sys_ivy_frontend/entity/person_adress_entity.dart';

import 'inclusion_exclusion_entity.dart';

class PersonEntity extends InclusionExclusionEntity {
  int? idPerson;
  String? name;
  String? personType;
  String? cpf;
  String? cnpj;
  String? sex;
  Timestamp? birthday;
  List<ContactEntity?>? listContact;
  List<PersonAdressEntity?>? listPersonAdress;
  bool isSelect = false;

  PersonEntity({
    this.idPerson,
    this.name,
    this.personType,
    this.cpf,
    this.cnpj,
    this.sex,
    this.birthday,
    this.listContact,
    this.listPersonAdress,
    this.isSelect = false,
    idOperatorInclusion,
    inclusionDate,
    idOperatorExclusion,
    exclusionDate,
  }) : super(
          idOperatorInclusion: idOperatorInclusion,
          inclusionDate: inclusionDate,
          idOperatorExclusion: idOperatorExclusion,
          exclusionDate: exclusionDate,
        );

  factory PersonEntity.fromDocument(DocumentSnapshot doc) {
    return PersonEntity(
      idPerson: int.parse(doc.id),
      name: doc.get('name'),
      personType: doc.get('personType'),
      cpf: doc.get('cpf'),
      cnpj: doc.get('cnpj'),
      sex: doc.get('sex'),
      birthday: doc.get('birthday'),
      listContact: (doc.get("listContact") as List<dynamic>).isEmpty
          ? []
          : (doc.get("listContact") as List<dynamic>)
              .map((e) => ContactEntity.fromLinkedHashMap(e))
              .toList(),
      listPersonAdress: (doc.get("listPersonAdress") as List<dynamic>).isEmpty
          ? []
          : (doc.get("listPersonAdress") as List<dynamic>)
              .map((e) => PersonAdressEntity.fromLinkedHashMap(e))
              .toList(),
      idOperatorExclusion: doc.get("idOperatorExclusion"),
      exclusionDate: doc.get("exclusionDate"),
      idOperatorInclusion: doc.get("idOperatorInclusion"),
      inclusionDate: doc.get("inclusionDate"),
    );
  }

  factory PersonEntity.fromLinkedHashMap(LinkedHashMap<dynamic, dynamic> map) {
    return PersonEntity(
      idPerson: map['idPerson'],
      name: map['name'],
      personType: map['personType'],
      cpf: map['cpf'],
      cnpj: map['cnpj'],
      sex: map['sex'],
      birthday: map['birthday'],
      listContact: map['listContact']
          .map((e) => ContactEntity.fromLinkedHashMap(e))
          .toList(),
      listPersonAdress: map['listPersonAdress']
          .map((e) => PersonAdressEntity.fromLinkedHashMap(e))
          .toList(),
      idOperatorExclusion: map['idOperatorExclusion'],
      exclusionDate: map['exclusionDate'],
      idOperatorInclusion: map['idOperatorInclusion'],
      inclusionDate: map['inclusionDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPerson': idPerson,
      'name': name,
      'personType': personType,
      'cpf': cpf,
      'cnpj': cnpj,
      'sex': sex,
      'birthday': birthday,
      'listContact': listContact?.map((e) => e?.toJson()).toList(),
      'listPersonAdress': listPersonAdress?.map((e) => e?.toJson()).toList(),
      'idOperatorInclusion': idOperatorInclusion,
      'inclusionDate': inclusionDate,
      'idOperatorExclusion': idOperatorExclusion,
      'exclusionDate': exclusionDate,
    };
  }
}
