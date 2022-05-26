import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sys_ivy_frontend/config/firestore_config.dart';
import 'package:sys_ivy_frontend/entity/product_entity.dart';
import 'package:sys_ivy_frontend/repos/category_repo.dart';
import 'package:sys_ivy_frontend/repos/repo.dart';

class ProductRepo extends Repo {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;
  late CategoryRepo _categoryRepo;

  // ----------------------------------------------------------
  // CONSTRUCTOR
  // ----------------------------------------------------------
  ProductRepo() {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _categoryRepo = CategoryRepo();
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

    ProductEntity pr = ProductEntity.fromDocument(snapshot);
    pr.category = await _categoryRepo.findById(pr.category!.idCategory!);

    return pr.exclusionDate == null ? pr : null;
  }

  @override
  Future<List<ProductEntity>> findAll() async {
    QuerySnapshot snapshot =
        await _firestore.collection(DaoConfig.PRODUCT_COLLECTION).get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    List<ProductEntity> list = snapshot.docs
        .map((doc) => ProductEntity.fromDocument(doc))
        .toList()
        .where((element) => element.exclusionDate == null)
        .toList();

    for (ProductEntity element in list) {
      element.category =
          await _categoryRepo.findById(element.category!.idCategory!);
    }

    return list;
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
    entity.inclusionDate = Timestamp.now();
    entity.idOperatorInclusion = _auth.currentUser?.uid;

    if (entity.idProduct == null) {
      // Create
      int? maxId = await findMaxID();
      entity.idProduct = (maxId == null ? 1 : (maxId + 1));

      _firestore
          .collection(DaoConfig.PRODUCT_COLLECTION)
          .doc(entity.idProduct.toString())
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

  Future<List<ProductEntity>> findAllByCategory(int idCategory) async {
    QuerySnapshot snapshot = await _firestore
        .collection(DaoConfig.PRODUCT_COLLECTION)
        .where('idCategory', isEqualTo: idCategory)
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    List<ProductEntity> list = snapshot.docs
        .map((doc) => ProductEntity.fromDocument(doc))
        .toList()
        .where((element) => element.exclusionDate == null)
        .toList();

    for (var element in list) {
      element.category =
          await _categoryRepo.findById(element.category!.idCategory!);
    }

    return list;
  }

  Future<List<ProductEntity>> findByName(String name) async {
    QuerySnapshot snapshot = await _firestore
        .collection(DaoConfig.PRODUCT_COLLECTION)
        .where('name', isEqualTo: name)
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    List<ProductEntity> list = snapshot.docs
        .map((doc) => ProductEntity.fromDocument(doc))
        .toList()
        .where((element) => element.exclusionDate == null)
        .toList();

    for (var element in list) {
      element.category =
          await _categoryRepo.findById(element.category!.idCategory!);
    }

    return list;
  }

  Future<List<ProductEntity>> findLikeByName(String name) async {
    List<ProductEntity> list = await findAll();

    if (list.isEmpty) {
      return [];
    }

    return list
        .where((element) =>
            element.name!.toLowerCase().contains(name.toLowerCase().trim()))
        .toList();
  }
}
