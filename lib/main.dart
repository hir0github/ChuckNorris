import 'dart:collection';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(App());
}

late var database;

Future<SplayTreeMap<String, dynamic>> getFavorites() async {
  var data = await database.get();

  late SplayTreeMap<String, dynamic> map;
  if (data.value != null) {
    map = SplayTreeMap<String, dynamic>.from(data.value as Map);
  }
  return map;
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final Future<FirebaseApp> _fireApp = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      name: "Tinder with Chuck");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: _fireApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              database = FirebaseDatabase.instanceFor(
                      app: snapshot.data as FirebaseApp)
                  .ref('data');
              return const Home();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
