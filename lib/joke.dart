import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
part 'joke.g.dart';

@JsonSerializable()
class Joke {
  final String jokesAPI = 'https://api.chucknorris.io/jokes/random?category=';
  late Future<String> data;

  @JsonKey(name: 'value')
  String joke;
  Joke(this.joke);
  factory Joke.fromJson(Map<String, dynamic> json) => _$JokeFromJson(json);
  Map<String, dynamic> toJson() => _$JokeToJson(this);

  void updateData(String currentCategory) {
    data = getData(jokesAPI + currentCategory);
  }

  Widget getJoke() {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const CircularProgressIndicator();
            } else {
              joke = Joke.fromJson(jsonDecode(snapshot.data.toString())).joke;
              return SizedBox(
                  height: 200,
                  child: ListView(children: [
                    Text(joke,
                        style: const TextStyle(
                            fontFamily: 'Helvetica', fontSize: 18)),
                  ]));
            }
          },
        ));
  }

  Future<String> getData(String url) async {
    try {
      var result = await http.get(Uri.parse(url));
      return result.body;
    } catch (error) {
      return error.toString();
    }
  }
}
