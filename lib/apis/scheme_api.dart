import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empowher/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schemeAPIProvider = Provider((ref) {
  final db = ref.watch(firestoreProvider);
  return SchemeAPI(db: db);
});

abstract class ISchemeAPI {
  Future<List<Map<String, dynamic>>> getSchemes(String? state);
}

class SchemeAPI implements ISchemeAPI {
  final FirebaseFirestore _db;
  SchemeAPI({required FirebaseFirestore db}) : _db = db;

  @override
  Future<List<Map<String, dynamic>>> getSchemes(String? state) async {
    try {
      List<QueryDocumentSnapshot> list;
      if (state == null || state == 'All') {
        list = (await _db.collection('schemes').get()).docs;
      } else {
        list = (await _db.collection('schemes').where('state', isEqualTo: state).get()).docs;
      }
      List<Map<String, dynamic>> schemes = [];
      for (var doc in list) {
        schemes.add(doc.data() as Map<String, dynamic>);
      }
      return schemes;
    } catch (error, stackTrace) {
      throw Failure(error.toString(), stackTrace);
    }
  }
}
