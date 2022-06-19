import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  FavoritesState() {
    getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: const Text(
          'Favorites',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data as SplayTreeMap<String, dynamic>;
            return ListView(
              children: data.keys.map((e) {
                return Column(
                  children: [
                    Image.network(data[e]['image']),
                    Text(data[e]['joke']),
                  ],
                );
              }).toList(),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
        future: getFavorites(),
      ),
    ));
  }
}
