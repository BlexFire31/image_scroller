import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_scroller/constants.dart';
import 'package:image_scroller/util/getUserData.dart';
import 'package:image_scroller/util/image_card/generateImageCardRows.dart';
import 'package:image_scroller/widgets/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  SharedPreferences? sharedPreferences;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height * 0.65;

    return FutureBuilder(
      future: (() async {
        sharedPreferences = await SharedPreferences.getInstance();
        Map<String, dynamic> userData = await getUserData(sharedPreferences);
        List<String> liked = userData['liked'];
        return liked;
      })(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "Favorites...",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          body: (() {
            if (snapshot.hasData && snapshot.data != null) {
              List<Map<String, dynamic>> results = snapshot.data!
                  .map((url) => {
                        "height": 1,
                        "width": 1,
                        "image": url,
                        "title": "",
                      })
                  .toList();

              List<Row> imageCardRows = generateImageCardRows(
                results,
                maxImages,
                screenHeight,
                minHeight,
                screenWidth,
                0,
                (String url) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewImage(url: url),
                  ));
                },
                false,
              );

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                addAutomaticKeepAlives: true,
                itemCount: imageCardRows.length,
                itemBuilder: (context, index) => imageCardRows[index],
              );
            }

            return const Loading();
          })(),
        );
      },
    );
  }
}

class ViewImage extends StatelessWidget {
  const ViewImage({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: '0$url',
                child: CachedNetworkImage(
                  imageUrl: url,
                ),
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
