import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empowher/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userAPIProvider = Provider((ref) {
  final db = ref.watch(firestoreProvider);
  return UserAPI(db: db);
});

abstract class IUserAPI {
  Future<Failure?> saveUserData({required String uid, required Map<String, dynamic> user});
  Future<Failure?> updateUserData({required String uid, required Map<String, dynamic> data});
  Future<DocumentSnapshot> getUserData(String uid);
}

class UserAPI implements IUserAPI {
  final FirebaseFirestore _db;
  UserAPI({required FirebaseFirestore db}) : _db = db;

  @override
  Future<Failure?> saveUserData({required String uid, required Map<String, dynamic> user}) async {
    try {
      await _db.collection('users').doc(uid).set(user);
      return null;
    } catch (error, stackTrace) {
      return Failure(error.toString(), stackTrace);
    }
  }

  @override
  Future<DocumentSnapshot> getUserData(String uid) async {
    try {
      return await _db.collection('users').doc(uid).get();
    } catch (error, stackTrace) {
      throw Failure(error.toString(), stackTrace);
    }
  }

  @override
  Future<Failure?> updateUserData({required String uid, required Map<String, dynamic> data}) async {
    try {
      await _db.collection('users').doc(uid).update(data);
      return null;
    } catch (error, stackTrace) {
      return Failure(error.toString(), stackTrace);
    }
  }
}
