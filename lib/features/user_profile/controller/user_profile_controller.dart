import 'dart:io';

import 'package:empowher/apis/post_api.dart';
import 'package:empowher/apis/storage_api.dart';
import 'package:empowher/apis/user_api.dart';
import 'package:empowher/common/common.dart';
import 'package:empowher/models/post_model.dart';
import 'package:empowher/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileControllerProvider = StateNotifierProvider.autoDispose<UserProfileController, bool>(
  (ref) => UserProfileController(
    postAPI: ref.watch(postAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
  ),
);

final getUserPostsProvider = FutureProvider.autoDispose.family((ref, String userId) async {
  final userProfileController = ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserPosts(userId: userId);
});

class UserProfileController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final UserAPI _userAPI;
  final StorageAPI _storageAPI;

  UserProfileController({required PostAPI postAPI, required UserAPI userAPI, required StorageAPI storageAPI})
      : _postAPI = postAPI,
        _userAPI = userAPI,
        _storageAPI = storageAPI,
        super(false);

  Future<List<Post>> getUserPosts({required String userId}) async {
    final posts = await _postAPI.getUserPosts(userId: userId);
    return posts.map((post) => Post.fromMap(post.data() as Map<String, dynamic>)).toList();
  }

  void updateUserDetails({required UserModel user, required BuildContext context, File? profilePic, File? bannerPic}) async {
    try {
      state = true;
      if (bannerPic != null) {
        final bannerUrl = await _storageAPI.uploadFiles(files: [bannerPic], path: 'banner');
        user = user.copyWith(bannerPic: bannerUrl[0]);
      }
      if (profilePic != null) {
        final photoUrl = await _storageAPI.uploadFiles(files: [profilePic], path: 'profile');
        user = user.copyWith(photoURL: photoUrl[0]);
      }
      final res = await _userAPI.saveUserData(user: user.toMap().remove('uid'), uid: user.uid);
      state = false;
      if (context.mounted) {
        if (res != null) {
          showSnackBar(context, res.message);
        } else {
          Navigator.pop(context);
        }
      }
    } catch (error) {
      return;
    }
  }

  void followUser({required UserModel user, required UserModel currentUser, required BuildContext context}) async {
    try {
      state = true;
      if (currentUser.following.contains(user.uid)) {
        currentUser.following.remove(user.uid);
        user.followers.remove(currentUser.uid);
      } else {
        currentUser.following.add(user.uid);
        user.followers.add(currentUser.uid);
      }
      final res1 = await _userAPI.updateUserData(uid: currentUser.uid, data: {
        'following': currentUser.following,
      });
      final res2 = await _userAPI.updateUserData(uid: user.uid, data: {
        'followers': user.followers,
      });
      state = false;
      if (context.mounted) {
        if (res1 != null || res2 != null) {
          showSnackBar(context, res1?.message ?? res2!.message);
        }
      }
    } catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.toString());
      }
    }
  }
}
