import 'package:flutter/material.dart';
import 'package:image_scroller/util/image_card/generateImageCardRow.dart';

List<Row> generateImageCardRows(
  List results,
  int maxImages,
  double screenHeight,
  double minHeight,
  double screenWidth,
  int screenLevel, [
  void Function(String url)? onPressed,
  bool? useMemCache,
]) {
  List<Row> imageCardRows = [];
  int index = 0;
  while (index != results.length) {
    Row row = generateImageCardRow(
      results,
      maxImages,
      screenHeight,
      minHeight,
      screenWidth,
      index,
      screenLevel,
      useMemCache ?? true,
      onPressed,
    );
    imageCardRows.add(row);
    index += row.children.length;
  }
  return imageCardRows;
}
