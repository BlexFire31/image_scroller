import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_scroller/constants.dart';
import 'package:image_scroller/util/duckDuckGoSearch.dart';
import 'package:image_scroller/util/image_card/generateImageCardRows.dart';
import 'package:image_scroller/widgets/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends SearchDelegate {
  SearchPage({required this.sharedPreferences});

  SharedPreferences sharedPreferences;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height * 0.65;

    List<String> searchHistory =
        sharedPreferences.getStringList('_search_history')!;
    if (!searchHistory.contains(query)) {
      sharedPreferences.setStringList(
        '_search_history',
        searchHistory + [query],
      );
    }
    return FutureBuilder(
      future: (() async {
        String? result = await duckDuckGoSearch(query);

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
          List<Row> imageCardRows = generateImageCardRows(
            results,
            maxImages,
            screenHeight,
            minHeight,
            screenWidth,
            0,
          );

          return ListView.builder(
            addAutomaticKeepAlives: true,
            itemCount: imageCardRows.length,
            itemBuilder: (context, index) => imageCardRows[index],
          );
        }
        return const Loading();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> searchHistory =
        sharedPreferences.getStringList('_search_history')!;
    if (query.trim().isNotEmpty) {
      searchHistory.removeWhere((word) {
        List<String> wordChars = word.toLowerCase().characters.toList();
        List<String> queryChars =
            query.toLowerCase().trim().characters.toList();
        for (String char in queryChars) {
          if (char == ' ') continue;
          int initialLength = wordChars.length;
          wordChars.remove(char);
          if (wordChars.length == initialLength) return true;
        }
        return false;
      });

      final listTiles = searchHistory
          .map((word) {
            List<String> queryChars =
                query.toLowerCase().trim().characters.toList();
            List<String> wordChars = word.characters.toList();
            return WordAndChars(
              word: word,
              chars: wordChars.map((char) {
                if (queryChars.contains(char.toLowerCase())) {
                  queryChars.remove(char.toLowerCase());
                  return TextSpan(
                    text: char,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                } else {
                  return TextSpan(
                    text: char,
                  );
                }
              }).toList(),
            );
          })
          .map((wordAndChars) => ListTile(
                title: Text.rich(
                  TextSpan(
                    text: '',
                    children: wordAndChars.chars,
                  ),
                ),
                onTap: () {
                  query = wordAndChars.word;
                },
              ))
          .toList();

      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: listTiles.length,
        itemBuilder: ((context, index) => listTiles[index]),
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: searchHistory.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(searchHistory[index]),
        onTap: () {
          query = searchHistory[index];
        },
      ),
    );
  }
}

class WordAndChars {
  const WordAndChars({
    required this.word,
    required this.chars,
  });
  final String word;
  final List<TextSpan> chars;
}
