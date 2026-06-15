import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// LÜTFEN DİKKAT: Bu dosya geçicidir. Gerçek projenize bağlamak için
/// terminalde `flutterfire configure` komutunu çalıştırın.
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
          'you can reconfigure this by running the flutterfire configure command.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the flutterfire configure command.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDCTGSmFyiVV62wsxZpPmluCVoccx-FlyU',
    appId: '1:955249476929:web:2afc8c3768eaa7596e0dc0',
    messagingSenderId: '955249476929',
    projectId: 'notiva-ca2f6',
    authDomain: 'notiva-ca2f6.firebaseapp.com',
    storageBucket: 'notiva-ca2f6.firebasestorage.app',
    measurementId: 'G-HLR540J601',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdyp3W0h3H7w0g6Lu-35evaZ1VQP-hnfc',
    appId: '1:955249476929:android:0dd47611c4b4f64e6e0dc0',
    messagingSenderId: '955249476929',
    projectId: 'notiva-ca2f6',
    storageBucket: 'notiva-ca2f6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKQi8thzlqQa-RnQ8yDOU3sPwqyhlwexQ',
    appId: '1:955249476929:ios:1433c9f0633e911c6e0dc0',
    messagingSenderId: '955249476929',
    projectId: 'notiva-ca2f6',
    storageBucket: 'notiva-ca2f6.firebasestorage.app',
    androidClientId: '955249476929-587mb3183abkujktoq208msptrm29jm8.apps.googleusercontent.com',
    iosClientId: '955249476929-1l2gfpitov4s4bvhrm5iv4b04b7kreca.apps.googleusercontent.com',
    iosBundleId: 'com.notiva.notivaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'DUMMY_API_KEY',
    appId: '1:1234567890:ios:abcdef',
    messagingSenderId: '1234567890',
    projectId: 'notiva-app-dummy',
    storageBucket: 'notiva-app-dummy.appspot.com',
    iosBundleId: 'com.example.notivaApp',
  );
}