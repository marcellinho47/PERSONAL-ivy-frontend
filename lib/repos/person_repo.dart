import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sys_ivy_frontend/entity/person_entity.dart';

import '../config/firestore_config.dart';
import 'repo.dart';

class PersonRepo extends Repo {
  // ----------------------------------------------------------
  // VARIABLES
  // ----------------------------------------------------------
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;

  // ----------------------------------------------------------
  // CONSTRUCTOR
  // ----------------------------------------------------------
  PersonRepo() {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
  }

  // ----------------------------------------------------------
  // METHODS
  // ----------------------------------------------------------

  @override
  void delete(int id) async {
    PersonEntity? pe = await findById(id);

    if (pe == null) {
      return;
    }

    pe.idOperatorInclusion = _auth.currentUser?.uid;
    pe.exclusionDate = Timestamp.now();

    _firestore
        .collection(DaoConfig.CLIENTS_COLLECTION)
        .doc(id.toString())
        .update(pe.toJson());
  }

  @override
  void deleteAll(List<int> ids) {
    for (int id in ids) {
      delete(id);
    }
  }

  @override
  Future<List<PersonEntity>> findAll() async {
    QuerySnapshot snapshot =
        await _firestore.collection(DaoConfig.CLIENTS_COLLECTION).get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs
        .map((doc) => PersonEntity.fromDocument(doc))
        .toList()
        .where((element) => element.exclusionDate == null)
        .toList();
  }

  @override
  Future<PersonEntity?> findById(int id) async {
    DocumentSnapshot snapshot = await _firestore
        .collection(DaoConfig.CLIENTS_COLLECTION)
        .doc(id.toString())
        .get();

    PersonEntity pr = PersonEntity.fromDocument(snapshot);

    return pr.exclusionDate == null ? pr : null;
  }

  @override
  Future<int?> findMaxID() async {
    QuerySnapshot snapshot =
        await _firestore.collection(DaoConfig.CLIENTS_COLLECTION).get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    return snapshot.docs
        .map((doc) => PersonEntity.fromDocument(doc).idPerson)
        .toList()
        .last;
  }

  @override
  Future<PersonEntity?> save(Object entity) async {
    entity = entity as PersonEntity;
    entity.inclusionDate = Timestamp.now();
    entity.idOperatorInclusion = _auth.currentUser?.uid;

    if (entity.idPerson == null) {
      // Create
      int? maxId = await findMaxID();
      entity.idPerson = (maxId == null ? 1 : (maxId + 1));

      _firestore
          .collection(DaoConfig.CLIENTS_COLLECTION)
          .doc(entity.idPerson.toString())
          .set(entity.toJson());
    } else {
      // Update
      _firestore
          .collection(DaoConfig.CLIENTS_COLLECTION)
          .doc(entity.idPerson.toString())
          .update(entity.toJson());
    }

    return entity;
  }
}
