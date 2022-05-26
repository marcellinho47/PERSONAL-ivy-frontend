import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sys_ivy_frontend/entity/operator_entity.dart';

import '../config/firestore_config.dart';

class OperatorRepo {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;

  // ----------------------------------------------------------
  // CONSTRUCTOR
  // ----------------------------------------------------------
  OperatorRepo() {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
  }

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------
  delete(String id) async {
    OperatorEntity? op = await findById(id);

    if (op == null) {
      return;
    }

    op.idOperatorInclusion = _auth.currentUser?.uid;
    op.exclusionDate = Timestamp.now();

    _firestore
        .collection(DaoConfig.OPERATOR_COLLECTION)
        .doc(id.toString())
        .update(op.toJson());
  }

  deleteAll(List<String> ids) {
    for (String id in ids) {
      delete(id);
    }
  }

  Future<List<OperatorEntity>> findAll() async {
    QuerySnapshot snapshot =
        await _firestore.collection(DaoConfig.OPERATOR_COLLECTION).get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs
        .map((doc) => OperatorEntity.fromDocument(doc))
        .toList()
        .where((element) => element.exclusionDate == null)
        .toList();
  }

  Future<OperatorEntity?> findById(String id) async {
    DocumentSnapshot snapshot = await _firestore
        .collection(DaoConfig.OPERATOR_COLLECTION)
        .doc(id)
        .get();

    OperatorEntity op = OperatorEntity.fromDocument(snapshot);

    return op.exclusionDate == null ? op : null;
  }

  Future<OperatorEntity> save(Object entity) async {
    entity = entity as OperatorEntity;

    // Authentication
    if (entity.idOperator == null || entity.idOperator!.isEmpty) {
      // Create
      UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: entity.login!,
        password: entity.password!,
      );
      entity.idOperator = user.user!.uid;
    } else {
      // Update
      _auth.currentUser!.updateEmail(entity.login!);
      _auth.currentUser!.updatePassword(entity.password!);
      _auth.currentUser!.updateDisplayName(entity.name!);
      _auth.currentUser!.updatePhotoURL(entity.imageURL);
    }

    // Firestore
    if (entity.idOperatorInclusion == null) {
      entity.idOperatorInclusion = _auth.currentUser!.uid;
      entity.inclusionDate = Timestamp.now();
    }
    entity.password = "";

    await _firestore
        .collection(DaoConfig.OPERATOR_COLLECTION)
        .doc(entity.idOperator)
        .set(entity.toJson());

    return entity;
  }

  void updateimageURL(String id, String imageURL) {
    _firestore
        .collection(DaoConfig.OPERATOR_COLLECTION)
        .doc(id)
        .update({'imageURL': imageURL});
  }

  Future<List<OperatorEntity>> findByName(String name) async {
    QuerySnapshot snapshot = await _firestore
        .collection(DaoConfig.OPERATOR_COLLECTION)
        .where('name', isEqualTo: name)
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs
        .map((doc) => OperatorEntity.fromDocument(doc))
        .toList()
        .where((element) => element.exclusionDate == null)
        .toList();
  }

  Future<List<OperatorEntity?>> findByLogin(String login) async {
    QuerySnapshot snapshot = await _firestore
        .collection(DaoConfig.OPERATOR_COLLECTION)
        .where('login', isEqualTo: login.toLowerCase().trim())
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs
        .map((doc) => OperatorEntity.fromDocument(doc))
        .toList()
        .where((element) => element.exclusionDate == null)
        .toList();
  }
}
