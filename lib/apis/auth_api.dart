import 'package:empowher/core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authAPIProvider = Provider((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInAuthProvider);
  return AuthAPI(firebaseAuth: firebaseAuth, googleSignIn: googleSignIn);
});

abstract class IAuthAPI {
  Future<(Failure?, UserCredential?)> signUpWithEmail({required String email, required String password});
  Future<(Failure?, UserCredential?)> loginWithEmail({required String email, required String password});
  Future<(Failure?, UserCredential?)> signInWithGoogle();
  Stream<User?> get currentUser;
  Future<Failure?> logout();
}

class AuthAPI implements IAuthAPI {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  AuthAPI({required this.firebaseAuth, required this.googleSignIn});

  @override
  Future<(Failure?, UserCredential?)> signUpWithEmail({required String email, required String password}) async {
    try {
      final account = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return (null, account);
    } on FirebaseAuthException catch (e, stackTrace) {
      return (Failure(e.message ?? 'An unknown error occurred!', stackTrace), null);
    } catch (e, stackTrace) {
      return (Failure(e.toString(), stackTrace), null);
    }
  }

  @override
  Future<(Failure?, UserCredential?)> loginWithEmail({required String email, required String password}) async {
    try {
      return (null, await firebaseAuth.signInWithEmailAndPassword(email: email, password: password));
    } on FirebaseAuthException catch (e, stackTrace) {
      return (Failure(e.message ?? 'An unknown error occurred!', stackTrace), null);
    } catch (e, stackTrace) {
      return (Failure(e.toString(), stackTrace), null);
    }
  }

  @override
  Stream<User?> get currentUser => firebaseAuth.authStateChanges();

  @override
  Future<Failure?> logout() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
      return null;
    } on FirebaseAuthException catch (e, stackTrace) {
      return Failure(e.message ?? 'An unknown error occurred!', stackTrace);
    } catch (e, stackTrace) {
      return Failure(e.toString(), stackTrace);
    }
  }

  @override
  Future<(Failure?, UserCredential?)> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = (await googleSignIn.signIn())!;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      return (null, userCredential);
    } on FirebaseAuthException catch (e, stackTrace) {
      return (Failure(e.message ?? 'An unknown error occurred!', stackTrace), null);
    } catch (e, stackTrace) {
      return (Failure(e.toString(), stackTrace), null);
    }
  }
}
