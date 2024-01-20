import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final googleSignInAuthProvider = Provider((ref) => GoogleSignIn());
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final storageProvider = Provider((ref) => FirebaseStorage.instance);
final geminiProvider = Provider((ref) => Gemini.instance);
