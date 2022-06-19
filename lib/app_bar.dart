import 'package:flutter/material.dart';
import 'favorites.dart';
import 'home.dart';

PreferredSizeWidget? appBar(BuildContext context, HomeState homeScreen) {
  return AppBar(
      backgroundColor: Colors.amber[700],
      toolbarHeight: 40,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Tinder with Chuck!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          DropdownButton<String>(
            value: currentCategory,
            onChanged: (String? newValue) {
              homeScreen.setState(() {
                currentCategory = newValue!;
              });
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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
