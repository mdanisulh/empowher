import 'dart:io';

import 'package:empowher/core/core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageAPIProvider = Provider.autoDispose((ref) {
  final storage = ref.watch(storageProvider);
  return StorageAPI(storage: storage);
});

class StorageAPI {
  final FirebaseStorage _storage;
  StorageAPI({required FirebaseStorage storage}) : _storage = storage;

  Future<List<String>> uploadFiles({required List<File> files, required String path}) async {
    List<String> fileLinks = [];
    for (final file in files) {
      final ref = _storage.ref().child('$path/${file.path.split('/').last}');
      final uploadTask = ref.putFile(file);
      final taskSnapshot = await uploadTask.whenComplete(() {});
      final url = await taskSnapshot.ref.getDownloadURL();
      fileLinks.add(url);
    }
    return fileLinks;
  }
}
