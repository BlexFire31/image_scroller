import 'package:flutter/material.dart';
import 'package:image_scroller/data/color_name_maps.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getUserData(
    [SharedPreferences? sharedPreferences]) async {
  sharedPreferences ??= await SharedPreferences.getInstance();

  if (sharedPreferences.getBool('_setup_completed') != true) {
    return {
      'setup_completed': false,
      'fav_color': Colors.grey,
    };
  }

  Map<String, dynamic> keysAndValues = {};

  keysAndValues['setup_completed'] = true;
  keysAndValues['fav_color'] =
      names_and_colors[sharedPreferences.getString('_fav_color')];
  keysAndValues['search_history'] =
      sharedPreferences.getStringList('_search_history');
  keysAndValues['see_more_of'] =
      sharedPreferences.getStringList('_see_more_of');
  keysAndValues['liked'] = sharedPreferences.getStringList('_liked');
  keysAndValues['disliked'] = sharedPreferences.getStringList('_disliked');

  keysAndValues['data'] = <String, int>{};
  for (var key in (sharedPreferences.getKeys()
    ..removeAll({
      '_setup_completed',
      '_fav_color',
      '_search_history',
      '_see_more_of',
      '_disliked',
      '_liked',
    }))) {
    keysAndValues['data'][key] = sharedPreferences.getInt(key)!;
  }
  return keysAndValues;
}
