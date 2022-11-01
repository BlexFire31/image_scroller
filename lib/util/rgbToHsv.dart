import 'dart:math';

// https://www.w3resource.com/python-exercises/math/python-math-exercise-77.php
List<int> rgbToHsv(double r, double g, double b) {
  double h = 0;
  double s = 0;
  double v = 0;

  double mx = 0.0;
  double mn = 0.0;
  double df = 0.0;

  r = r / 255.0;
  g = g / 255.0;
  b = b / 255.0;

  mx = max(max(r, g), b);
  mn = min(min(r, g), b);

  df = mx - mn;

  if (mx == mn) {
    h = 0;
  } else if (mx == r) {
    h = (60 * ((g - b) / df) + 360) % 360;
  } else if (mx == g) {
    h = (60 * ((b - r) / df) + 120) % 360;
  } else if (mx == b) {
    h = (60 * ((r - g) / df) + 240) % 360;
  }

  if (mx == 0) {
    s = 0;
  } else {
    s = (df / mx) * 100;
  }
  v = mx * 100;

  return [h.round(), s.round(), v.round()];
}
