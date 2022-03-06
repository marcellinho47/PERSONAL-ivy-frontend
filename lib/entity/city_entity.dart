import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/state_entity.dart';

class CityEntity {
  int? idCity;
  int? idIBGE;
  String? name;
  StateEntity? state;

  CityEntity({
    this.idCity,
    this.idIBGE,
    this.name,
    this.state,
  });

  factory CityEntity.fromDocument(DocumentSnapshot doc) {
    return CityEntity(
        idCity: int.parse(doc.id),
        idIBGE: doc.get("idIBGE"),
        name: doc.get("name"),
        state: doc.get("state"));
  }

  Map<String, dynamic> toJson() =>
      {'idIBGE': idIBGE, 'name': name, 'state': state};
}
