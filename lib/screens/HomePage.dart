import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_scroller/constants.dart';
import 'package:image_scroller/data/color_name_maps.dart';
import 'package:image_scroller/screens/Favorites.dart';
import 'package:image_scroller/screens/SearchPage.dart';
import 'package:image_scroller/util/getUserData.dart';

import 'package:image_scroller/util/image_card/generateImageCardRows.dart';
import 'package:image_scroller/util/duckDuckGoSearch.dart';
import 'package:image_scroller/widgets/ExpandableFab.dart';
import 'package:image_scroller/widgets/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences? sharedPreferences;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height * 0.65;

    return FutureBuilder(
      future: (() async {
        Random random = Random();
        sharedPreferences = await SharedPreferences.getInstance();
        Map<String, dynamic> userData = await getUserData(sharedPreferences);

        /* Generate dynamic search query */
        Map<String, int> pictureRatings = userData['data'];
        if (pictureRatings.keys.isEmpty) {
          List<String> seeMoreOf = userData['see_more_of'];

          String? result = await duckDuckGoSearch(
            '${colors_and_names[userData['fav_color']]!.replaceAll("Accent", "")} color ${seeMoreOf[random.nextInt(seeMoreOf.length)]}',
          );
          return result ?? "ERROR";
        }
        int highest = (pictureRatings.values.toList()..sort()).reversed.first;
        List<String> topics = (pictureRatings
              ..removeWhere((key, value) => value != highest))
            .keys
            .toList();

        String? result =
            await duckDuckGoSearch(topics[random.nextInt(topics.length)]);
        return result ?? "ERROR";
      })(),
      builder: (context, snapshot) {
        return Scaffold(
          body: (() {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data == "ERROR") {
                return const Center(
                  child: Text(
                    "Error fetching results...",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
              List results = jsonDecode(snapshot.data!)['results'];
              List<Row> imageCardRows = generateImageCardRows(
                results,
                maxImages,
                screenHeight,
                minHeight,
                screenWidth,
                0,
              );

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  addAutomaticKeepAlives: true,
                  itemCount: imageCardRows.length,
                  itemBuilder: (context, index) => imageCardRows[index],
                ),
              );
            }

            return const Loading();
          })(),
          floatingActionButton: snapshot.data == null ||
                  snapshot.data == "ERROR"
              ? null
              : ExpandableFab(
                  distance: 72.0,
                  children: [
                    ActionButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate:
                              SearchPage(sharedPreferences: sharedPreferences!),
                        );
                      },
                    ),
                    ActionButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Favorites(),
                        ));
                      },
                    ),
                  ],
                  mainChildBuilder: (onClick) {
                    return FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        onClick();
                      },
                      child: Icon(
                        Icons.more_horiz,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
