// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCTQJZOVJu-ypA52jEMVDBdwJLRLANK1lU',
    appId: '1:1003318079648:web:65fdb8f6d1c2b04c6319c5',
    messagingSenderId: '1003318079648',
    projectId: 'fir-chat-dd927',
    authDomain: 'fir-chat-dd927.firebaseapp.com',
    storageBucket: 'fir-chat-dd927.appspot.com',
    measurementId: 'G-V11V7BP6YY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2ACOgNLf8aQTnV0Ayu5q4WOFMVGh_-VA',
    appId: '1:1003318079648:android:f306862cb191005c6319c5',
    messagingSenderId: '1003318079648',
    projectId: 'fir-chat-dd927',
    storageBucket: 'fir-chat-dd927.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkxBQUFtGobnp_VVldwTii-6lOLJ0QX-o',
    appId: '1:1003318079648:ios:4026be712225ee9a6319c5',
    messagingSenderId: '1003318079648',
    projectId: 'fir-chat-dd927',
    storageBucket: 'fir-chat-dd927.appspot.com',
    androidClientId: '1003318079648-fqm85mfogobeae2dfetqvrpm5qhrtufj.apps.googleusercontent.com',
    iosClientId: '1003318079648-v7uit2un55bb5er7kcr0tb2mdcks7e4q.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );
}