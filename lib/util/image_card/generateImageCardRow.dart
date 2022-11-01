import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_scroller/widgets/ImageCard.dart';

Row generateImageCardRow(
    List<dynamic> results,
    int maxImages,
    double screenHeight,
    double minHeight,
    double screenWidth,
    int index,
    int screenLevel,
    bool useMemCache,
    [void Function(String url)? onPressed]) {
  Map result = results[index];

  Random random = Random();

  int noOfImages = random.nextInt(maxImages) + 1;
  if (results.length - index <= maxImages) {
    noOfImages = results.length - index;
  }

  double height = random.nextDouble() * screenHeight;
  if (height < minHeight) {
    height = min(screenHeight, height + minHeight);
  }

  // if noOfImages is 1, fill the whole screen and return the row
  if (noOfImages == 1) {
    return Row(children: [
      ImageCard(
        height: height,
        width: screenWidth,
        url: result['image'],
        title: result['title'],
        originalHeight: result['height'],
        originalWidth: result['width'],
        screenLevel: screenLevel,
        useMemCache: useMemCache,
        onPressed: onPressed,
      ),
    ]);
  }

  // Generating images
  List<Widget> images = [];
  double randDouble;
  double minWidth = screenWidth / (noOfImages * 2);
  if (noOfImages == 3) {
    // First image
    randDouble = random.nextDouble() *
        // max width (3 sections)
        (3 * minWidth);
    // if the width of the image is below minimum width
    if (randDouble < minWidth) {
      randDouble += minWidth;
    }
    images.add(
      ImageCard(
        height: height,
        width: randDouble,
        url: result['image'],
        title: result['title'],
        originalHeight: result['height'],
        originalWidth: result['width'],
        screenLevel: screenLevel,
        useMemCache: useMemCache,
        onPressed: onPressed,
      ),
    );
    index++;
    result = results[index];
    double widthOfFirstImage = randDouble;

    // Second image
    randDouble = random.nextDouble() *
        // max width ( we leave space for at least one more section)
        (screenWidth - (widthOfFirstImage + minWidth));

    // if the width of the image is below minimum width
    if (randDouble < minWidth) {
      randDouble = min(
        screenWidth - (widthOfFirstImage + minWidth),
        randDouble + minWidth,
      );
    }
    images.add(
      ImageCard(
        height: height,
        width: randDouble,
        url: result['image'],
        title: result['title'],
        originalHeight: result['height'],
        originalWidth: result['width'],
        screenLevel: screenLevel,
        useMemCache: useMemCache,
        onPressed: onPressed,
      ),
    );
    index++;
    result = results[index];

    // Third image (fill leftover space)
    images.add(
      ImageCard(
        height: height,
        width: screenWidth - (widthOfFirstImage + randDouble),
        url: result['image'],
        title: result['title'],
        originalHeight: result['height'],
        originalWidth: result['width'],
        screenLevel: screenLevel,
        useMemCache: useMemCache,
        onPressed: onPressed,
      ),
    );
  } else /* noOfImages is 2 */ {
    // First image
    randDouble = random.nextDouble() *
        // max width ( we leave space for at least one more section)
        (3 * minWidth);

    // if the width of the image is below minimum width
    if (randDouble < minWidth) {
      randDouble = min(
        (3 * minWidth),
        randDouble + minWidth,
      );
    }
    images.add(
      ImageCard(
        height: height,
        width: randDouble,
        url: result['image'],
        title: result['title'],
        originalHeight: result['height'],
        originalWidth: result['width'],
        screenLevel: screenLevel,
        useMemCache: useMemCache,
        onPressed: onPressed,
      ),
    );
    index++;
    result = results[index];

    // Second image (fill leftover space)
    images.add(
      ImageCard(
        height: height,
        width: screenWidth - randDouble,
        url: result['image'],
        title: result['title'],
        originalHeight: result['height'],
        originalWidth: result['width'],
        screenLevel: screenLevel,
        useMemCache: useMemCache,
        onPressed: onPressed,
      ),
    );
  }

  return Row(
    children: images,
  );
}
