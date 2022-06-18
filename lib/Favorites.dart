import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  List<Widget> favorites;
  Favorites(this.favorites);

  @override
  FavoritesState createState() => FavoritesState(favorites);
}

class FavoritesState extends State<Favorites> {
  FavoritesState(this.Favorites);
  List<Widget> Favorites;

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
      body: ListView(
        children: Favorites,
      ),
    ));
  }
}
