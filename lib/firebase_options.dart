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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDzrE41ohHzt74Pj18Y-855xDl-_QO2Kkw',
    appId: '1:383070410348:web:74c8b6e0d7ef12eb05aa49',
    messagingSenderId: '383070410348',
    projectId: 'isblog-5f5ac',
    authDomain: 'isblog-5f5ac.firebaseapp.com',
    storageBucket: 'isblog-5f5ac.appspot.com',
    measurementId: 'G-QC9L9VB74F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTKu3s1infv9ceAFjwxiHO2opP0fSyTu8',
    appId: '1:383070410348:android:7d62a0a1425792f105aa49',
    messagingSenderId: '383070410348',
    projectId: 'isblog-5f5ac',
    storageBucket: 'isblog-5f5ac.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlnYeNMQ6CSz3xuGoFpBOmRtj7jF9Y4RA',
    appId: '1:383070410348:ios:2329cd46caa9e55805aa49',
    messagingSenderId: '383070410348',
    projectId: 'isblog-5f5ac',
    storageBucket: 'isblog-5f5ac.appspot.com',
    iosClientId: '383070410348-rbrg3gm8feoivjan27n6akuh47h6teoo.apps.googleusercontent.com',
    iosBundleId: 'com.example.iasblog',
  );
}