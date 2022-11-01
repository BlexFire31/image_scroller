import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_scroller/constants.dart';
import 'package:image_scroller/data/phrase_separators.dart';
import 'package:image_scroller/util/getUserData.dart';
import 'package:image_scroller/util/image_card/generateImageCardRows.dart';
import 'package:image_scroller/util/duckDuckGoSearch.dart';
import 'package:image_scroller/util/generateRandomColor.dart';
import 'package:image_scroller/util/rgbToHsv.dart';
import 'package:image_scroller/widgets/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewImage extends StatefulWidget {
  const ViewImage({
    super.key,
    required this.url,
    required this.title,
    required this.memCacheWidth,
    required this.memCacheHeight,
    required this.screenLevel,
  });

  final String url;
  final String title;
  final int memCacheWidth;
  final int memCacheHeight;
  final int screenLevel;

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  Color? appBarColor;
  bool liked = false;
  SharedPreferences? sharedPreferences;
  List<Widget>? imageCardRows;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height * 0.65;
    appBarColor ??= generateRandomColor(context);

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        elevation: 0.0,
        title: Text(widget.title),
        backgroundColor: appBarColor,
        foregroundColor: (() {
          List<int> hsv = rgbToHsv(
            appBarColor!.red.toDouble(),
            appBarColor!.green.toDouble(),
            appBarColor!.blue.toDouble(),
          );
          if (hsv[2] >= 10 && hsv[1] <= 60) {
            return Colors.black;
          }
          return Colors.white;
        })(),
      ),
      body: FutureBuilder(
        future: (() async {
          sharedPreferences = await SharedPreferences.getInstance();
          Map<String, dynamic> userData = await getUserData(sharedPreferences);
          String phrase = widget.title.toLowerCase();
          // "Images of red sceneries" to "    red sceneries"
          for (String separator in phrase_separators +
              ['image', 'images', 'picture', 'pictures', '!'] +
              [
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '0',
              ]) {
            phrase = phrase.replaceAll(separator, " ");
          }
          // "    red sceneries" to " red sceneries"
          List<String> phraseCharacters = phrase.characters.toList();
          for (int i = 0; i < phrase.length; i++) {
            int iPlusOne = min(i + 1, phraseCharacters.length - 1);
            if (phraseCharacters[i] == " " &&
                phraseCharacters[iPlusOne] == " ") {
              phraseCharacters[i] = "";
            }
          }
          phrase = phraseCharacters.join("");
          // " red sceneries" to "red sceneries"
          phrase = phrase.trim();

          List<String> phrases = [];
          List<String> phraseWords = phrase.split(' ');
          for (int i = 0; i < phraseWords.length; i++) {
            for (int j = i; j < phraseWords.length; j++) {
              phrases.add(phraseWords.sublist(i, j).join(" "));
            }
          }
          phrases.removeWhere((element) => element == "");
          for (String phrase in phrases) {
            sharedPreferences!.setInt(phrase, (userData[phrase] ?? 0) + 1);
          }
          liked = userData['liked'].contains(widget.url);

          String? result = await duckDuckGoSearch(widget.title);
          return result ?? "ERROR";
        })(),
        builder: (context, snapshot) {
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

            imageCardRows ??= generateImageCardRows(
              results,
              maxImages,
              screenHeight,
              minHeight,
              screenWidth,
              widget.screenLevel + 1,
            );

            List<Widget> widgets = <Widget>[
              Stack(
                children: [
                  Hero(
                    tag: widget.screenLevel.toString() + widget.url,
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
                      placeholder: (context, url) => CachedNetworkImage(
                        imageUrl: widget.url,
                        memCacheHeight: widget.memCacheHeight,
                        memCacheWidth: widget.memCacheWidth,
                        fadeInDuration: const Duration(seconds: 0),
                        fadeOutDuration: const Duration(seconds: 0),
                      ),
                      fadeInDuration: const Duration(seconds: 0),
                      fadeOutDuration: const Duration(seconds: 0),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: IconButton(
                      onPressed: () {
                        getUserData(sharedPreferences).then((value) {
                          liked = !liked;
                          if (liked) {
                            sharedPreferences!.setStringList(
                              '_liked',
                              value['liked'] + [widget.url],
                            );
                          } else {
                            List<String> liked = value['liked'];
                            liked.remove(widget.url);
                            sharedPreferences!.setStringList(
                              '_liked',
                              liked,
                            );
                          }
                          setState(() {});
                        });
                      },
                      icon:
                          Icon(liked ? Icons.favorite : Icons.favorite_border),
                      color: liked ? Colors.red : Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: screenWidth,
                height: 50.0,
                child: Row(
                  children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "More like this...",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...imageCardRows!,
            ];

            return ListView.builder(
              addAutomaticKeepAlives: true,
              itemCount: widgets.length,
              itemBuilder: (context, index) => widgets[index],
            );
          }

          return Column(
            children: [
              Hero(
                tag: widget.screenLevel.toString() + widget.url,
                child: CachedNetworkImage(
                  imageUrl: widget.url,
                  placeholder: (context, url) => CachedNetworkImage(
                    imageUrl: widget.url,
                    memCacheHeight: widget.memCacheHeight,
                    memCacheWidth: widget.memCacheWidth,
                    fadeInDuration: const Duration(seconds: 0),
                    fadeOutDuration: const Duration(seconds: 0),
                  ),
                  fadeInDuration: const Duration(seconds: 0),
                  fadeOutDuration: const Duration(seconds: 0),
                ),
              ),
              const Expanded(
                child: Loading(),
              ),
            ],
          );
        },
      ),
    );
  }
}
