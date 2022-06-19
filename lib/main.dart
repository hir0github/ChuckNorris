import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

late FirebaseApp fireApp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  fireApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      name: "Tinder with Chuck");

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(const App());
}

var database = FirebaseDatabase.instanceFor(app: fireApp).ref('data');

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
