import 'package:cloud_firestore/cloud_firestore.dart';

class ContactTypeEntity {
  int? idContactType;
  String? description;

  ContactTypeEntity({
    this.idContactType,
    this.description,
  });

  factory ContactTypeEntity.fromDocument(DocumentSnapshot doc) {
    return ContactTypeEntity(
        idContactType: int.parse(doc.id), description: doc.get("description"));
  }

  Map<String, dynamic> toJson() => {'description': description};
}
