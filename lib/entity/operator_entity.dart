import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/inclusion_exclusion_entity.dart';

class OperatorEntity extends InclusionExclusionEntity {
  String? idOperator;
  String? name;
  String? login;
  String? password;
  bool? isAdmin = false;
  String? imageURL;
  bool isSelect = false;

  OperatorEntity({
    this.idOperator,
    this.name,
    this.login,
    this.password,
    this.isAdmin,
    this.isSelect = false,
    this.imageURL,
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

  factory OperatorEntity.fromDocument(DocumentSnapshot doc) {
    return OperatorEntity(
      idOperator: doc.id,
      name: doc.get("name"),
      login: doc.get('login'),
      password: doc.get('password'),
      isAdmin: doc.get('isAdmin'),
      imageURL: doc.get('imageURL'),
      idOperatorInclusion: doc.get('idOperatorInclusion'),
      inclusionDate: doc.get('inclusionDate'),
      idOperatorExclusion: doc.get('idOperatorExclusion'),
      exclusionDate: doc.get('exclusionDate'),
    );
  }

  Map<String, dynamic> toJson() => {
        'idOperator': idOperator,
        'name': name,
        'login': login,
        'password': password,
        'isAdmin': isAdmin,
        'imageURL': imageURL,
        'idOperatorInclusion': idOperatorInclusion,
        'inclusionDate': inclusionDate,
        'idOperatorExclusion': idOperatorExclusion,
        'exclusionDate': exclusionDate
      };
}
