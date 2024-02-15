import 'dart:io';

import 'package:empowher/apis/post_api.dart';
import 'package:empowher/apis/storage_api.dart';
import 'package:empowher/common/common.dart';
import 'package:empowher/features/auth/controller/auth_controller.dart';
import 'package:empowher/models/post_model.dart';
import 'package:empowher/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postControllerProvider = StateNotifierProvider.autoDispose<PostController, bool>((ref) {
  return PostController(
    ref: ref,
    postAPI: ref.watch(postAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
  );
});

final getPostsProvider = FutureProvider.autoDispose((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPosts();
});

final getPostByIDProvider = FutureProvider.autoDispose.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId: postId);
});

final replyPostProvider = FutureProvider.autoDispose.family((ref, Post post) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.replyPost(post: post);
});

class PostController extends StateNotifier<bool> {
  final Ref _ref;
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  PostController({required Ref ref, required StorageAPI storageAPI, required PostAPI postAPI})
      : _ref = ref,
        _storageAPI = storageAPI,
        _postAPI = postAPI,
        super(false);

  Future<Post?> sharePost({
    required List<File> images,
    required String text,
    String repliedTo = '',
    required BuildContext context,
  }) async {
    if (text.isEmpty && images.isEmpty) {
      showSnackBar(context, 'Please enter some text or add an image!');
      return null;
    }
    state = true;
    final List<String> imageLinks;
    if (images.isNotEmpty) {
      imageLinks = await _storageAPI.uploadFiles(files: images, path: 'posts');
    } else {
      imageLinks = [];
    }
    final user = _ref.read(currentUserDetailsProvider).value!;
    Post post = Post(
      text: text,
      uid: user.uid,
      imageLinks: imageLinks,
      postedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      id: '',
      repliedTo: repliedTo,
    );
    final res = await _postAPI.sharePost(post: post);
    state = false;
    if (context.mounted) {
      if (res.$1 != null) {
        showSnackBar(context, res.$1!.message);
      } else {
        return post;
      }
    }
    return null;
  }

  Future<List<Post>> getPosts() async {
    final postList = await _postAPI.getPosts();
    return postList.map((doc) {
      Post post = Post.fromMap(doc.data() as Map<String, dynamic>);
      return post.copyWith(id: doc.id);
    }).toList();
  }

  void likePost(Post post, UserModel user) async {
    final likes = post.likes;
    if (likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }
    post = post.copyWith(likes: likes);
    await _postAPI.likePost(post: post);
  }

  Future<Post?> getPostById({required String postId}) async {
    final post = await _postAPI.getPostById(postId: postId);
    if (post == null) return null;
    return Post.fromMap(post.data() as Map<String, dynamic>).copyWith(id: postId);
  }

  void replyPost({required Post post}) async {
    await _postAPI.replyPost(post: post);
  }
}
