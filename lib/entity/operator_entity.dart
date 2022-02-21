import 'package:cloud_firestore/cloud_firestore.dart';

class OperatorEntity {
  String? idOperator;
  String? login;
  String? password;
  bool? isAdmin = false;
  String? idOperatorInclusion;
  Timestamp? inclusionDate;
  String? idOperatorExclusion;
  Timestamp? exclusionDate;
  bool isSelect = false;

  OperatorEntity(
      {this.idOperator,
      this.login,
      this.password,
      this.isAdmin,
      this.isSelect = false,
      this.idOperatorInclusion,
      this.inclusionDate,
      this.idOperatorExclusion,
      this.exclusionDate});

  factory OperatorEntity.fromDocument(DocumentSnapshot doc) {
    return OperatorEntity(
        idOperator: doc.id,
        login: doc.get('login'),
        password: doc.get('password'),
        isAdmin: doc.get('isAdmin'),
        idOperatorInclusion: doc.get('idOperatorInclusion'),
        inclusionDate: doc.get('inclusionDate'),
        idOperatorExclusion: doc.get('idOperatorExclusion'),
        exclusionDate: doc.get('exclusionDate'));
  }

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
        'idAdmin': isAdmin,
        'idOperatorInclusion': idOperatorInclusion,
        'inclusionDate': inclusionDate,
        'idOperatorExclusion': idOperatorExclusion,
        'exclusionDate': exclusionDate
      };
}
