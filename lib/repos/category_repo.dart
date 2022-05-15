import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sys_ivy_frontend/entity/category_entity.dart';
import 'package:sys_ivy_frontend/repos/repo.dart';

import '../config/firestore_config.dart';

class CategoryRepo extends Repo {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;

  // ----------------------------------------------------------
  // CONSTRUCTOR
  // ----------------------------------------------------------
  CategoryRepo() {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
  }

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  @override
  deleteAll(List<int> ids) {
    for (int id in ids) {
      delete(id);
    }
  }

  @override
  delete(int id) async {
    CategoryEntity? cat = await findById(id);

    if (cat == null) {
      return;
    }

    cat.enabled = false;

    _firestore
        .collection(DaoConfig.CATEGORY_COLLECTION)
        .doc(id.toString())
        .update(cat.toJson());
  }

  @override
  Future<CategoryEntity?> findById(int id) async {
    DocumentSnapshot snapshot = await _firestore
        .collection(DaoConfig.CATEGORY_COLLECTION)
        .doc(id.toString())
        .get();

    return CategoryEntity.fromDocument(snapshot);
  }

  @override
  Future<List<CategoryEntity>> findAll() async {
    QuerySnapshot snapshot =
        await _firestore.collection(DaoConfig.PRODUCT_COLLECTION).get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs
        .map((doc) => CategoryEntity.fromDocument(doc))
        .toList();
  }

  @override
  Future<int?> findMaxID() async {
    QuerySnapshot snapshot =
        await _firestore.collection(DaoConfig.CATEGORY_COLLECTION).get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    return snapshot.docs
        .map((doc) => CategoryEntity.fromDocument(doc).idCategory)
        .toList()
        .last;
  }

  @override
  Future<CategoryEntity> save(Object entity) async {
    entity = entity as CategoryEntity;

    if (entity.idCategory == null) {
      // Create
      int? maxId = await findMaxID();

      entity.idCategory = maxId;

      _firestore
          .collection(DaoConfig.CATEGORY_COLLECTION)
          .doc(maxId == null ? '1' : (maxId + 1).toString())
          .set(entity.toJson());
    } else {
      // Update
      _firestore
          .collection(DaoConfig.CATEGORY_COLLECTION)
          .doc(entity.idCategory.toString())
          .update(entity.toJson());
    }

    return entity;
  }

  Future<List<CategoryEntity>> findAllEnabled() async {
    QuerySnapshot snapshot =
        await _firestore.collection(DaoConfig.PRODUCT_COLLECTION).get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs
        .map((doc) => CategoryEntity.fromDocument(doc))
        .where((element) => element.enabled!)
        .toList();
  }
}
