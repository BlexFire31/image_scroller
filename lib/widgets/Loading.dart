import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_scroller/util/rgbToHsv.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SpinKitThreeBounce(
            // color: Theme.of(context).primaryColor,
            size: min(
              50,
              constraints.maxHeight,
            ),
            itemBuilder: (context, index) => DecoratedBox(
              decoration: BoxDecoration(
                color: color ?? Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                border: (() {
                  List<int> hsv = rgbToHsv(
                    (color ?? Theme.of(context).primaryColor).red.toDouble(),
                    (color ?? Theme.of(context).primaryColor).green.toDouble(),
                    (color ?? Theme.of(context).primaryColor).blue.toDouble(),
                  );
                  if (hsv[2] >= 35 && hsv[1] <= 60) {
                    return Border.all(color: Colors.black);
                  }
                })(),
              ),
            ),
          );
        },
      ),
    );
  }
}
