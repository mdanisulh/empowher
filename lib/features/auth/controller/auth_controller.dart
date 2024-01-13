import 'package:empowher/apis/auth_api.dart';
import 'package:empowher/common/common.dart';
import 'package:empowher/features/auth/views/login_view.dart';
import 'package:empowher/features/home/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authAPI: ref.watch(authAPIProvider),
  ),
);

final currentUserAccountProvider = Provider(
  (ref) => ref.watch(authControllerProvider.notifier).currentUser(),
);

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);

  User? currentUser() => _authAPI.currentUserAccount();

  void signUpWithEmail({required String email, required String password, required BuildContext context}) async {
    state = true;
    final res = await _authAPI.signUpWithEmail(email: email, password: password);
    if (res.$2 != null) {
      if (context.mounted) {
        if (res.$1 == null) {
          showSnackBar(context, 'Account successfully created. Please login!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        } else {
          showSnackBar(context, res.$1!.message);
        }
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, res.$1!.message);
      }
    }
    state = false;
  }

  void loginWithEmail({required String email, required String password, required BuildContext context}) async {
    state = true;
    final res = await _authAPI.loginWithEmail(email: email, password: password);
    if (context.mounted) {
      if (res.$2 != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
      } else {
        showSnackBar(context, res.$1!.message);
      }
    }
    state = false;
  }

  void signInWithGoogle({required BuildContext context}) async {
    state = true;
    final res = await _authAPI.signInWithGoogle();
    if (context.mounted) {
      if (res.$2 != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
      } else {
        showSnackBar(context, res.$1!.message);
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
