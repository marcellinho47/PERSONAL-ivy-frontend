import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_ivy_frontend/entity/city_entity.dart';
import 'package:sys_ivy_frontend/repos/repo.dart';

import '../config/firestore_config.dart';

class CityRepo extends Repo {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  late FirebaseFirestore _firestore;

  // ----------------------------------------------------------
  // CONSTRUCTOR
  // ----------------------------------------------------------
  CityRepo() {
    _firestore = FirebaseFirestore.instance;
  }

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  void delete(int id) {}

  @override
  void deleteAll(List<int> ids) {}

  @override
  Future<List<CityEntity>> findAll() async {
    QuerySnapshot snapshot =
        await _firestore.collection(DaoConfig.CITY_COLLECTION).get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) => CityEntity.fromDocument(doc)).toList();
  }

  @override
  Future<CityEntity> findById(int id) async {
    DocumentSnapshot snapshot = await _firestore
        .collection(DaoConfig.CITY_COLLECTION)
        .doc(id.toString())
        .get();

    return CityEntity.fromDocument(snapshot);
  }

  @override
  Future<int?> findMaxID() async {
    QuerySnapshot snapshot =
        await _firestore.collection(DaoConfig.CITY_COLLECTION).get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    return snapshot.docs
        .map((doc) => CityEntity.fromDocument(doc).idCity)
        .toList()
        .last;
  }

  @override
  Future<CityEntity> save(Object entity) async {
    entity = entity as CityEntity;

    if (entity.idCity == null) {
      // Create
      int? maxId = await findMaxID();
      entity.idCity = (maxId == null ? 1 : (maxId + 1));

      _firestore
          .collection(DaoConfig.CITY_COLLECTION)
          .doc(entity.idCity.toString())
          .set(entity.toJson());
    } else {
      // Update
      _firestore
          .collection(DaoConfig.CITY_COLLECTION)
          .doc(entity.idCity.toString())
          .update(entity.toJson());
    }

    return entity;
  }

  Future<List<CityEntity>> saveAll(List<Object> entities) async {
    List<CityEntity> list = [];
    for (Object entity in entities) {
      list.add(await save(entity));
    }

    return list;
  }
}
