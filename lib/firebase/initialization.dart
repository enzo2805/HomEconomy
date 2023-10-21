// inicializa firebase
import 'package:firebase_core/firebase_core.dart';

Future<FirebaseApp> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp();
  assert(app != null);
  return app;
}