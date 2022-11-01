import 'package:firebase_core/firebase_core.dart';

class Config {
  static initFirebase() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBIafsPcS9eMauIuH12U9YjER2nL3HQyXU',
          appId: '1:748290765008:android:4b48441e408269fa526ed5',
          messagingSenderId: '',
          projectId: 'devhub-d486f'),
    );
  }
}
