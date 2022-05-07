import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sys_ivy_frontend/config/firestore_config.dart';
import 'package:sys_ivy_frontend/entity/product_entity.dart';
import 'package:sys_ivy_frontend/repos/repo.dart';

class ProductRepo extends Repo {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;

  // ----------------------------------------------------------
  // CONSTRUCTOR
  // ----------------------------------------------------------
  ProductRepo() {
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
    ProductEntity? pe = await findById(id);

    if (pe == null) {
      return;
    }

    pe.idOperatorInclusion = _auth.currentUser?.uid;
    pe.exclusionDate = Timestamp.now();

    _firestore
        .collection(DaoConfig.PRODUCT_COLLECTION)
        .doc(id.toString())
        .update(pe.toJson());
  }

  @override
  Future<ProductEntity?> findById(int id) async {
    DocumentSnapshot snapshot = await _firestore
        .collection(DaoConfig.PRODUCT_COLLECTION)
        .doc(id.toString())
        .get();

    ProductEntity product = ProductEntity.fromDocument(snapshot);

    return product.exclusionDate == null ? product : null;
  }

  @override
  Future<List<ProductEntity>> findAll() async {
    QuerySnapshot snapshot =
        await _firestore.collection(DaoConfig.PRODUCT_COLLECTION).get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs
        .map((doc) => ProductEntity.fromDocument(doc))
        .toList()
        .where((element) => element.exclusionDate == null)
        .toList();
  }

  @override
  Future<int?> findMaxID() async {
    QuerySnapshot snapshot =
        await _firestore.collection(DaoConfig.PRODUCT_COLLECTION).get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    return snapshot.docs
        .map((doc) => ProductEntity.fromDocument(doc).idProduct)
        .toList()
        .last;
  }

  @override
  Future<ProductEntity> save(Object entity) async {
    entity = entity as ProductEntity;

    if (entity.idProduct == null) {
      // Create
      int? maxId = await findMaxID();

      entity.idProduct = maxId;

      _firestore
          .collection(DaoConfig.PRODUCT_COLLECTION)
          .doc(maxId == null ? '1' : (maxId + 1).toString())
          .set(entity.toJson());
    } else {
      // Update
      _firestore
          .collection(DaoConfig.PRODUCT_COLLECTION)
          .doc(entity.idProduct.toString())
          .update(entity.toJson());
    }

    return entity;
  }
}
