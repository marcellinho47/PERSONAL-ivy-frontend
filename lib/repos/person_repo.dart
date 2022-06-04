import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  void delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  void deleteAll(List<int> ids) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future findAll() {
    // TODO: implement findAll
    throw UnimplementedError();
  }

  @override
  Future findById(int id) {
    // TODO: implement findById
    throw UnimplementedError();
  }

  @override
  Future<int?> findMaxID() {
    // TODO: implement findMaxID
    throw UnimplementedError();
  }

  @override
  Future save(Object entity) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
