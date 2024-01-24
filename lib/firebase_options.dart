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
    apiKey: 'AIzaSyCltyR5G_B0-QxRjmQRdeiqFtDejdbGa5E',
    appId: '1:482859517015:web:eccebd4b163efe21d30f12',
    messagingSenderId: '482859517015',
    projectId: 'paws-and-tail',
    authDomain: 'paws-and-tail.firebaseapp.com',
    storageBucket: 'paws-and-tail.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-i1LA6yAEZTPTsBFOCHu72cV3DvWKrQY',
    appId: '1:482859517015:android:8d2a46638de6eb2bd30f12',
    messagingSenderId: '482859517015',
    projectId: 'paws-and-tail',
    storageBucket: 'paws-and-tail.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDIxF-DWe-RyXpVhK4bfmeQfUL-EdVQehU',
    appId: '1:482859517015:ios:6b64cfdcf6abebc3d30f12',
    messagingSenderId: '482859517015',
    projectId: 'paws-and-tail',
    storageBucket: 'paws-and-tail.appspot.com',
    iosBundleId: 'com.example.pawsAndTail',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDIxF-DWe-RyXpVhK4bfmeQfUL-EdVQehU',
    appId: '1:482859517015:ios:66d05ff9d6675dc2d30f12',
    messagingSenderId: '482859517015',
    projectId: 'paws-and-tail',
    storageBucket: 'paws-and-tail.appspot.com',
    iosBundleId: 'com.example.pawsAndTail.RunnerTests',
  );
}
