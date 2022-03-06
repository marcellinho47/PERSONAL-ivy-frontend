import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/contact_type_entity.dart';

class ContactEntity {
  int? idContact;
  ContactTypeEntity? contactType;
  String? description;

  ContactEntity({
    this.idContact,
    this.contactType,
    this.description,
  });

  factory ContactEntity.fromDocument(DocumentSnapshot doc) {
    return ContactEntity(
        idContact: int.parse(doc.id),
        contactType: doc.get("contactType"),
        description: doc.get("description"));
  }

  Map<String, dynamic> toJson() =>
      {'contactType': contactType, 'description': description};
}
