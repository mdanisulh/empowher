import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empowher/core/core.dart';
import 'package:empowher/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postAPIProvider = Provider.autoDispose((ref) {
  final database = ref.watch(firestoreProvider);
  return PostAPI(database: database);
});

abstract class IPostAPI {
  Future<DocumentSnapshot?> getPostById({required String postId});
  Future<List<DocumentSnapshot>> getPosts();
  Future<List<DocumentSnapshot>> getUserPosts({required String userId});
  Future<(Failure?, DocumentReference<Map<String, dynamic>>?)> sharePost({required Post post});
  Future<Failure?> likePost({required Post post});
  Future<Failure?> replyPost({required Post post});
}

class PostAPI implements IPostAPI {
  final FirebaseFirestore _database;
  PostAPI({required FirebaseFirestore database}) : _database = database;

  @override
  Future<(Failure?, DocumentReference<Map<String, dynamic>>?)> sharePost({required Post post}) async {
    try {
      final document = await _database.collection('posts').add(post.toMap());
      return (null, document);
    } catch (e, stackTrace) {
      return (Failure(e.toString(), stackTrace), null);
    }
  }

  @override
  Future<List<DocumentSnapshot>> getPosts() async {
    try {
      final documentList = await _database.collection('posts').get();
      return documentList.docs.map((doc) => doc).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Failure?> likePost({required Post post}) async {
    try {
      await _database.collection('posts').doc(post.id).update({'likes': post.likes});
      return null;
    } catch (e, stackTrace) {
      return Failure(e.toString(), stackTrace);
    }
  }

  @override
  Future<DocumentSnapshot?> getPostById({required String postId}) async {
    try {
      final post = await _database.collection('posts').doc(postId).get();
      return post;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Failure?> replyPost({required Post post}) async {
    try {
      await _database.collection('posts').doc(post.id).update({'commentIds': post.commentIds});
      return null;
    } catch (e, stackTrace) {
      return Failure(e.toString(), stackTrace);
    }
  }

  @override
  Future<List<DocumentSnapshot>> getUserPosts({required String userId}) async {
    try {
      final documentList = (await _database.collection('posts').where('uid', isEqualTo: userId).get());
      return documentList.docs.map((doc) => doc).toList();
    } catch (e) {
      return [];
    }
  }
}
