import 'dart:collection';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'main.dart';

late HomeState homeScreen;

class Favorites extends StatefulWidget {
  Favorites(HomeState homePage, {Key? key}) : super(key: key) {
    homeScreen = homePage;
  }

  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        centerTitle: true,
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const Text(
            'Favorites',
            style: TextStyle(color: Colors.black),
          ),
          InkWell(
            child: const Icon(Icons.delete, size: 25.0, color: Colors.black),
            onTap: () {
              database.remove();
              likeButtonPressed = false;
              setState(() {});
              homeScreen.setState(() {});
            },
          ),
        ]),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50))),
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
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 15, top: 20),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Image.network(data[e]['image'],
                                    width: 150, height: 150, fit: BoxFit.fill),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(data[e]['joke'])),
                            ]))),
                  ],
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text("No favorite jokes"));
          }
        },
        future: getFavorites(),
      ),
    ));
  }
}
