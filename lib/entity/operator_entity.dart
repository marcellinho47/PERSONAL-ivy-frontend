import 'package:cloud_firestore/cloud_firestore.dart';

class OperatorEntity {
  String? idOperator;
  String? login;
  String? password;
  bool? isAdmin = false;
  bool isSelect = false;

  OperatorEntity({
    this.idOperator,
    this.login,
    this.password,
    this.isAdmin,
    this.isSelect = false
  });

  factory OperatorEntity.fromDocument(DocumentSnapshot doc) {
    return OperatorEntity(
        idOperator: doc.id,
        login: doc.get('login'),
        password: doc.get('password'),
        isAdmin: doc.get('isAdmin'));
  }
}
