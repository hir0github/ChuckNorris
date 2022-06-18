import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:swipe/swipe.dart';
import 'package:json_annotation/json_annotation.dart';
import 'AppBar.dart';

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
