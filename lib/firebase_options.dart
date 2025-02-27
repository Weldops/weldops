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
    apiKey: 'AIzaSyCpLrGUEnsK0OVdCpF6_4Y7f_hcUk9RdSw',
    appId: '1:833294760549:android:4f29658a43e3d8bab5a48c',
    messagingSenderId: '833294760549',
    projectId: 'weldops',
    authDomain: 'weldops.firebaseapp.com',
    storageBucket: 'weldops.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCpLrGUEnsK0OVdCpF6_4Y7f_hcUk9RdSw',
    appId: '1:833294760549:android:4f29658a43e3d8bab5a48c',
    messagingSenderId: '833294760549',
    projectId: 'weldops',
    storageBucket: 'weldops.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPhnPYJG5GDxV1Xd_1T366Y4Bjf-EjsbE',
    appId: '1:833294760549:android:4f29658a43e3d8bab5a48c',
    messagingSenderId: '833294760549',
    projectId: 'weldops',
    storageBucket: 'weldops.firebasestorage.app',
    iosBundleId: 'com.company.weldopsdev',
  );
}
