import 'package:empowher/apis/auth_api.dart';
import 'package:empowher/apis/user_api.dart';
import 'package:empowher/common/common.dart';
import 'package:empowher/features/auth/views/login_view.dart';
import 'package:empowher/features/home/views/home_view.dart';
import 'package:empowher/features/home/views/onboarding_view.dart';
import 'package:empowher/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  ),
);

final currentUserProvider = StreamProvider<User?>(
  (ref) => ref.read(authAPIProvider).currentUser,
);

final userDetailsProvider = FutureProvider.family<UserModel?, String>((ref, uid) async {
  final data = await ref.read(userAPIProvider).getUserData(uid);
  final Map<String, dynamic> userData = data.data() as Map<String, dynamic>;
  userData['uid'] = uid;
  return UserModel.fromMap(userData);
});

final currentUserDetailsProvider = StreamProvider<UserModel?>((ref) async* {
  final user = ref.watch(currentUserProvider).value;
  if (user != null) {
    yield await ref.read(userDetailsProvider(user.uid).future);
  }
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  void signUpWithEmail({required String email, required String password, required BuildContext context}) async {
    state = true;
    final res = await _authAPI.signUpWithEmail(email: email, password: password);
    if (res.$2 != null) {
      final user = res.$2!.user;
      if (user != null) {
        final response = await _userAPI.saveUserData(uid: user.uid, user: {
          'email': user.email,
          'name': user.displayName ?? '',
          'photoURL': user.photoURL ?? 'https://firebasestorage.googleapis.com/v0/b/empowher24.appspot.com/o/default_profile.png?alt=media',
          'age': -1,
          'gender': 'O',
        });
        if (context.mounted) {
          if (response == null) {
            showSnackBar(context, 'Account successfully created!');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingView()),
            );
          } else {
            showSnackBar(context, response.message);
          }
        }
      }
    } else if (context.mounted) {
      showSnackBar(context, res.$1!.message);
    }
    state = false;
  }

  void loginWithEmail({required String email, required String password, required BuildContext context}) async {
    state = true;
    final res = await _authAPI.loginWithEmail(email: email, password: password);
    if (res.$2 != null) {
      final user = (await _userAPI.getUserData(res.$2!.user!.uid)).data() as Map<String, dynamic>;
      if (context.mounted) {
        if (user['age'] == -1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OnboardingView(),
            ),
          );
        }
      } else if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
      }
    } else if (context.mounted) {
      showSnackBar(context, res.$1!.message);
    }
    state = false;
  }

  void signInWithGoogle({required BuildContext context}) async {
    state = true;
    try {
      final res = await _authAPI.signInWithGoogle();
      final dataSnapshot = await _userAPI.getUserData(res.$2!.user!.uid);
      if (!dataSnapshot.exists) {
        final user = res.$2!.user;
        if (user != null) {
          await _userAPI.saveUserData(uid: user.uid, user: {
            'email': user.email,
            'name': user.displayName,
            'photoURL': user.photoURL ?? 'https://firebasestorage.googleapis.com/v0/b/empowher24.appspot.com/o/default_profile.png?alt=media',
            'age': -1,
            'gender': 'O',
          });
        }
      }
      if (context.mounted) {
        if (res.$2 != null) {
          if ((dataSnapshot.data() as Map<String, dynamic>)['age'] == -1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const OnboardingView(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeView(),
              ),
            );
          }
        } else {
          showSnackBar(context, res.$1!.message);
        }
      }
    } catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.toString());
      }
    }
    state = false;
  }

  void logout({required BuildContext context}) async {
    state = true;
    final res = await _authAPI.logout();
    if (context.mounted) {
      if (res == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
        );
      } else {
        showSnackBar(context, res.message);
      }
    }
    state = false;
  }
}
