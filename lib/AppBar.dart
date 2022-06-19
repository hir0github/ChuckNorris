import 'package:flutter/material.dart';
import 'Favorites.dart';
import 'Home.dart';

PreferredSizeWidget? appBar(BuildContext context, HomeState homeScreen) {
  return AppBar(
      backgroundColor: Colors.amber[700],
      toolbarHeight: 40,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Tinder with Chuck!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          Column(
            children: [
              InkWell(
                child:
                    const Icon(Icons.favorite, size: 25.0, color: Colors.red),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Favorites(homeScreen),
                    ),
                  );
                },
              ),
              const Text(
                'Favorites',
                style: TextStyle(fontSize: 8, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50))));
}
