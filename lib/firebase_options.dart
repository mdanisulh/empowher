// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAMBxe6MBE9lPvODzM8WaFMP2s8syEcF2k',
    appId: '1:341584119348:web:0b7fe37b777f5ac25fec61',
    messagingSenderId: '341584119348',
    projectId: 'empowher24',
    authDomain: 'empowher24.firebaseapp.com',
    storageBucket: 'empowher24.appspot.com',
    measurementId: 'G-K0FJBZFC51',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGgbsuL7jpGuahRGMsHU0_77XR_W7JV_s',
    appId: '1:341584119348:android:a8d7a0224101bbc65fec61',
    messagingSenderId: '341584119348',
    projectId: 'empowher24',
    storageBucket: 'empowher24.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuXJQhmg6VbKFOWxyppgMuZBqreNJKs8o',
    appId: '1:341584119348:ios:bd38c590c68a5b335fec61',
    messagingSenderId: '341584119348',
    projectId: 'empowher24',
    storageBucket: 'empowher24.appspot.com',
    iosClientId: '341584119348-dnc7455c6ei3ja2iiuu1judbgujir0s8.apps.googleusercontent.com',
    iosBundleId: 'co.anicoder.empowher',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAuXJQhmg6VbKFOWxyppgMuZBqreNJKs8o',
    appId: '1:341584119348:ios:aa85b1275a182f4b5fec61',
    messagingSenderId: '341584119348',
    projectId: 'empowher24',
    storageBucket: 'empowher24.appspot.com',
    iosClientId: '341584119348-sqrap3pc5bbk0otjovpv7i6bgp3405n0.apps.googleusercontent.com',
    iosBundleId: 'co.anicoder.empowher.RunnerTests',
  );
}
