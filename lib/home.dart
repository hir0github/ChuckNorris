import 'package:flutter/material.dart';
import 'package:swipe/swipe.dart';
import 'app_bar.dart';
import 'main.dart';
import 'joke.dart';
import 'picture.dart';
import 'favorites.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

bool likeButtonPressed = false;
List<String> categories = [
  "animal",
  "career",
  "celebrity",
  "dev",
  "explicit",
  "fashion",
  "food",
  "history",
  "money",
  "movie",
  "music",
  "political",
  "religion",
  "science",
  "sport",
  "travel"
];
String currentCategory = 'animal';

class HomeState extends State<Home> {
  var picture = Picture();
  var joke = Joke('');

  void updateHomeScreen(String currentCategory) {
    likeButtonPressed = false;
    joke.updateData(currentCategory);
    picture.updateData();
  }

  @override
  initState() {
    super.initState();
    updateHomeScreen(currentCategory);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: appBar(context, this),
            backgroundColor: Colors.white,
            body: Swipe(
                onSwipeLeft: () =>
                    setState(() => updateHomeScreen(currentCategory)),
                onSwipeRight: () =>
                    setState(() => updateHomeScreen(currentCategory)),
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
                                  picture.getPicture(),
                                  joke.getJoke(),
                                ],
                              ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () => setState(
                                  () => updateHomeScreen(currentCategory)),
                              color: Colors.amber[700],
                              iconSize: 60,
                              icon: const Icon(Icons.thumb_up_alt_outlined)),
                          IconButton(
                            onPressed: () async {
                              setState(() {
                                likeButtonPressed = !likeButtonPressed;
                              });

                              if (likeButtonPressed) {
                                await database.push().set({
                                  'joke': joke.joke,
                                  'image': picture.imageUrl
                                });
                              } else {
                                var data = await getFavorites();

                                var sortedKeys = data.keys.toList()..sort();
                                String lastKey =
                                    sortedKeys[sortedKeys.length - 1];
                                await database.child(lastKey).remove();
                              }
                            },
                            iconSize: 60,
                            icon: Icon(
                                likeButtonPressed
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ])))));
  }
}
