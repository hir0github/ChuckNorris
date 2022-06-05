import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:swipe/swipe.dart';
import 'package:json_annotation/json_annotation.dart';
part 'main.g.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

late Future<String> joke;
late Future<String> chuckImage;

class HomeState extends State<Home> {
  final String picAPI =
      'https://serpapi.com/search.json?engine=google&q=chuck+norris&google_domain=google.com&tbm=isch&ijn=0&api_key=0c1d759b8d4795a3c9f3847e923f3162bd873f3ba9fcd9a8f732a6d0fec1897b';
  final String jokesAPI = 'https://api.chucknorris.io/jokes/random';

  @override
  void initState() {
    super.initState();
    joke = getData(jokesAPI);
    chuckImage = getData(picAPI);
  }

  Future<String> getData(String url) async {
    try {
      var result = await http.get(Uri.parse(url));
      return result.body;
    } catch (error) {
      return error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.amber[700],
                toolbarHeight: 30,
                title: const Text(
                  'Tinder with Chuck!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50)))),
            backgroundColor: Colors.white,
            body: Swipe(
                onSwipeLeft: () {
                  setState(() {
                    joke = getData(jokesAPI);
                    chuckImage = getData(picAPI);
                  });
                },
                onSwipeRight: () {
                  setState(() {
                    joke = getData(jokesAPI);
                    chuckImage = getData(picAPI);
                  });
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
                                  Picture().pictureWidget,
                                  Joke().jokeWidget,
                                ],
                              ))),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              joke = getData(jokesAPI);
                              chuckImage = getData(picAPI);
                            });
                          },
                          color: Colors.amber[700],
                          iconSize: 60,
                          icon: const Icon(Icons.thumb_up_alt_outlined)),
                    ])))));
  }
}

@JsonSerializable()
class JokeData {
  @JsonKey(name: 'value')
  final String joke;
  JokeData(this.joke);
  factory JokeData.fromJson(Map<String, dynamic> json) =>
      _$JokeDataFromJson(json);
  Map<String, dynamic> toJson() => _$JokeDataToJson(this);
}

class Joke {
  Widget jokeWidget = Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: joke,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const CircularProgressIndicator();
          } else {
            var newJoke =
                JokeData.fromJson(jsonDecode(snapshot.data.toString()));
            return Center(
              child: Text(newJoke.joke,
                  style:
                      const TextStyle(fontFamily: 'Helvetica', fontSize: 16)),
            );
          }
        },
      ));
}

class Picture {
  Widget pictureWidget = Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 4,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder(
        future: chuckImage,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const CircularProgressIndicator();
          } else {
            Map<String, dynamic> pictures =
                jsonDecode(snapshot.data.toString());
            var random = Random();

            int n = random.nextInt(100);
            String url = pictures['images_results'][n]['original'].toString();

            Widget tmp =
                Image.network(url, width: 250, height: 250, fit: BoxFit.fill,
                    errorBuilder: (context, exception, stackTrace) {
              return Image.network(
                  pictures['images_results'][0]['original'].toString(),
                  width: 250,
                  height: 250);
            });
            return tmp;
          }
        },
      ));
}
