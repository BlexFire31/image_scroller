// https://stackoverflow.com/questions/72202158/how-to-convert-hsv-to-rgb-in-flutter
List<int> hsvToRgb(double H, double S, double V) {
  int R, G, B;

  H /= 360;
  S /= 100;
  V /= 100;

  if (S == 0) {
    R = (V * 255).toInt();
    G = (V * 255).toInt();
    B = (V * 255).toInt();
  } else {
    double varH = H * 6;
    if (varH == 6) varH = 0; // H must be < 1
    int varI = varH.floor(); // Or ... var_i =
    // floor( var_h )
    double var_1 = V * (1 - S);
    double var_2 = V * (1 - S * (varH - varI));
    double var_3 = V * (1 - S * (1 - (varH - varI)));

    double varR;
    double varG;
    double varB;
    if (varI == 0) {
      varR = V;
      varG = var_3;
      varB = var_1;
    } else if (varI == 1) {
      varR = var_2;
      varG = V;
      varB = var_1;
    } else if (varI == 2) {
      varR = var_1;
      varG = V;
      varB = var_3;
    } else if (varI == 3) {
      varR = var_1;
      varG = var_2;
      varB = V;
    } else if (varI == 4) {
      varR = var_3;
      varG = var_1;
      varB = V;
    } else {
      varR = V;
      varG = var_1;
      varB = var_2;
    }

    R = (varR * 255).toInt(); // RGB results from 0 to 255
    G = (varG * 255).toInt();
    B = (varB * 255).toInt();
  }

  return [R, G, B];
}
