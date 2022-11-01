import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_scroller/data/color_name_maps.dart';

import 'package:image_scroller/screens/HomePage.dart';
import 'package:image_scroller/screens/Setup.dart';
import 'package:image_scroller/util/MyHttpOverrides.dart';
import 'package:image_scroller/util/getUserData.dart';
import 'package:image_scroller/util/rgbToHsv.dart';
import 'package:image_scroller/widgets/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences? sharedPreferences;
  Map<String, dynamic> keysAndValues = {};
  // This widget is the root of your application.
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) async {
      sharedPreferences = value;

      keysAndValues = await getUserData(sharedPreferences);
      if (keysAndValues['setup_completed'] != true) {
        sharedPreferences!.setBool('_setup_completed', false);
      }

      while (!mounted) {}
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (sharedPreferences == null) {
      return MaterialApp(
        title: "Image Scroller",
        theme: ThemeData(primarySwatch: Colors.grey),
        home: const Scaffold(
          body: Loading(),
        ),
      );
    }
    ThemeData data = ThemeData(
      primaryColor: keysAndValues['fav_color'],
    );
    return MaterialApp(
      title: 'Image Scroller',
      theme: data.copyWith(
        colorScheme: data.colorScheme.copyWith(
          onPrimary: (() {
            List<int> hsv = rgbToHsv(
              keysAndValues['fav_color'].red.toDouble(),
              keysAndValues['fav_color'].green.toDouble(),
              keysAndValues['fav_color'].blue.toDouble(),
            );
            if (hsv[2] >= 10 && hsv[1] <= 60) {
              return Colors.black;
            }
            return Colors.white;
          })(),
        ),
      ),
      home: (() {
        if (keysAndValues['setup_completed'] == false) {
          // Future.delayed(const Duration(seconds: 5)).then(
          //   (value) => setState(() {
          //     keysAndValues['setup_completed'] = true;
          //   }),
          // );
          return Setup(onSetupComplete: (selectedColor, topics) {
            sharedPreferences!
                .setString('_fav_color', colors_and_names[selectedColor]!);
            sharedPreferences!.setStringList('_see_more_of', topics);
            sharedPreferences!.setStringList('_search_history', []);
            sharedPreferences!.setStringList('_liked', []);
            sharedPreferences!.setStringList('_disliked', []);
            sharedPreferences!.setBool('_setup_completed', true);

            SharedPreferences.getInstance().then((value) async {
              sharedPreferences = value;
              keysAndValues = await getUserData(sharedPreferences);
              setState(() {});
            });
          });
        }
        return const HomePage();
      })(),
    );
  }
}
