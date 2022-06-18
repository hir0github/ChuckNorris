import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:swipe/swipe.dart';
import 'package:json_annotation/json_annotation.dart';
import 'AppBar.dart';
part 'Home.g.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final String picAPI =
      'https://serpapi.com/search.json?engine=google&q=chuck+norris&google_domain=google.com&tbm=isch&ijn=0&api_key=0c1d759b8d4795a3c9f3847e923f3162bd873f3ba9fcd9a8f732a6d0fec1897b';
  final String jokesAPI = 'https://api.chucknorris.io/jokes/random';

  List<Widget> favoritesData = [];

  var pictures = Picture();
  var jokes = JokeData('');

  bool likeButtonPressed = false;

  late Future<String> dataPic;
  late Future<String> dataJoke;

  @override
  initState() {
    super.initState();
    dataJoke = getData(jokesAPI);
    dataPic = getRandomPicture(picAPI);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: appBar(context, favoritesData),
            backgroundColor: Colors.white,
            body: Swipe(
                onSwipeLeft: () {
                  setState(() {});
                },
                onSwipeRight: () {
                  setState(() {});
                },
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Expanded(
                          child: Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  pictures.getPicture(dataPic),
                                  jokes.getJoke(dataJoke),
                                ],
                              ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  dataJoke = getData(jokesAPI);
                                  dataPic = getRandomPicture(picAPI);
                                  likeButtonPressed = false;
                                });
                              },
                              color: Colors.amber[700],
                              iconSize: 60,
                              icon: const Icon(Icons.thumb_up_alt_outlined)),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                likeButtonPressed = !likeButtonPressed;
                              });
                              if (likeButtonPressed) {
                                favoritesData.add(Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.network(pictures.savedLink,
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.fill),
                                        Text(jokes.joke),
                                      ],
                                    )));
                              } else {
                                favoritesData.removeLast();
                              }
                            },
                            iconSize: 60,
                            icon: Icon(
                                likeButtonPressed
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red),
                          )
                        ],
                      ),
                    ])))));
  }

  Future<String> getData(String url) async {
    try {
      var result = await http.get(Uri.parse(url));
      return result.body;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> getRandomPicture(String url) async {
    try {
      var result = await http.get(Uri.parse(url));

      Map<String, dynamic> pictures = await jsonDecode(result.body);

      var random = Random();
      int n = random.nextInt(100);
      String ans = pictures['images_results'][n]['thumbnail'].toString();
      return ans;
    } catch (error) {
      return error.toString();
    }
  }
}

@JsonSerializable()
class JokeData {
  @JsonKey(name: 'value')
  String joke;
  JokeData(this.joke);
  factory JokeData.fromJson(Map<String, dynamic> json) =>
      _$JokeDataFromJson(json);
  Map<String, dynamic> toJson() => _$JokeDataToJson(this);

  Widget getJoke(Future<String> data) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const CircularProgressIndicator();
            } else {
              joke =
                  JokeData.fromJson(jsonDecode(snapshot.data.toString())).joke;
              return Center(
                child: Text(joke,
                    style:
                        const TextStyle(fontFamily: 'Helvetica', fontSize: 16)),
              );
            }
          },
        ));
  }
}

class Picture {
  late String savedLink;

  Widget getPicture(Future<String> data) {
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
              savedLink = snapshot.data.toString();
              return Image.network(savedLink,
                  width: 250, height: 250, fit: BoxFit.fill);
            }
          },
        ));
  }
}
