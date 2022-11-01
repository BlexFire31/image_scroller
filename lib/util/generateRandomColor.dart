import 'package:flutter/material.dart';
import 'dart:math';

import 'package:image_scroller/util/hsvToRgb.dart';
import 'package:image_scroller/util/rgbToHsv.dart';

Color generateRandomColor(BuildContext context) {
  Color primaryColor = Theme.of(context).primaryColor;
  Random random = Random();

  List<int> hsv = rgbToHsv(
    primaryColor.red.toDouble(),
    primaryColor.green.toDouble(),
    primaryColor.blue.toDouble(),
  );
  hsv[1] = hsv[1] <= 20 ? random.nextInt(20) : random.nextInt(100);
  hsv[2] = random.nextInt(100);

  // Get a random number between -20 and +20 and add that to hsv[0] (hue)
  hsv[0] += random.nextInt(40) - 20;

  // If hue not in range of 0 to 360
  if (hsv[0] > 360) {
    hsv[0] -= 360;
  } else if (hsv[0] < 0) {
    hsv[0] += 360;
  }

  List<int> rgb = hsvToRgb(
    hsv[0].toDouble(),
    hsv[1].toDouble(),
    hsv[2].toDouble(),
  );

  return Color.fromRGBO(
    rgb[0],
    rgb[1],
    rgb[2],
    random.nextDouble(),
  );
}
