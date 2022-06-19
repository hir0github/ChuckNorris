import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class Picture {
  final String picAPI =
      'https://serpapi.com/search.json?engine=google&q=chuck+norris&google_domain=google.com&tbm=isch&ijn=0&api_key=0c1d759b8d4795a3c9f3847e923f3162bd873f3ba9fcd9a8f732a6d0fec1897b';

  late String imageUrl;
  late Future<String> data;

  void updateData() {
    data = getRandomPicture();
  }

  Widget getPicture() {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 4,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FutureBuilder(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const CircularProgressIndicator();
            } else {
              imageUrl = snapshot.data.toString();
              return Image.network(imageUrl,
                  width: 250, height: 250, fit: BoxFit.fill);
            }
          },
        ));
  }

  Future<String> getRandomPicture() async {
    try {
      var result = await http.get(Uri.parse(picAPI));
      Map<String, dynamic> pictures = jsonDecode(result.body);

      var random = Random();
      int n = random.nextInt(100);
      return pictures['images_results'][n]['thumbnail'].toString();
    } catch (error) {
      return error.toString();
    }
  }
}
