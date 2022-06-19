import 'dart:collection';

import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  final Future<FirebaseApp> _fireApp = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      name: "Tinder with Chuck");

  App({Key? key}) : super(key: key);

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
