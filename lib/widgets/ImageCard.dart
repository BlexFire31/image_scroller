import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_scroller/screens/ViewImage.dart';
import 'package:image_scroller/util/generateRandomColor.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required this.title,
    required this.url,
    required this.width,
    required this.height,
    required this.originalWidth,
    required this.originalHeight,
    required this.screenLevel,
    this.onPressed,
    this.useMemCache = true,
  });

  final String title;
  final String url;
  final double width;
  final double height;
  final int originalHeight;
  final int screenLevel;
  final int originalWidth;
  final void Function(String url)? onPressed;
  final bool useMemCache;

  @override
  Widget build(BuildContext context) {
    int longestOriginalPictureSide = max(originalHeight, originalWidth);
    double longestPictureSide = max(width, height);

    double downscaleFactor =
        (longestOriginalPictureSide / longestPictureSide) * 0.7;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: generateRandomColor(context),
      ),
      child: TextButton(
        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        onPressed: onPressed != null
            ? () {
                onPressed!(url);
              }
            : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewImage(
                      url: url,
                      title: title,
                      memCacheWidth: originalWidth ~/ downscaleFactor,
                      memCacheHeight: originalHeight ~/ downscaleFactor,
                      screenLevel: screenLevel,
                    ),
                  ),
                );
              },
        child: Hero(
          tag: screenLevel.toString() + url,
          child: CachedNetworkImage(
            width: width,
            height: height,

            memCacheHeight:
                useMemCache ? originalHeight ~/ downscaleFactor : null,
            memCacheWidth:
                useMemCache ? originalWidth ~/ downscaleFactor : null,
            // memCacheHeight: height.toInt(),
            // memCacheWidth: width.toInt(),
            fit: BoxFit.cover,
            imageUrl: url,
          ),
        ),
      ),
    );
    // return Image.network(
    //   url,
    //   width: width,
    //   height: height,
    //   fit: BoxFit.cover,
    // );
  }
}
