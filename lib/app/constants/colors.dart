import 'package:flutter/material.dart';

const kBaseColor = Color(0xFF159ebf);
const kBaseColor1 = Color(0xFF1ab2bf);
const kBaseColor2 = Color(0xFF0777b9);

const textColor1 = Color(0xFF6E6E6E);
const whiteColor = Colors.white;
const textColor2 = Colors.black87;
const whiteBackgroundColor = Colors.white;

const MaterialColor kBaseColorToDark = MaterialColor(
  0xFF159ebf, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
  <int, Color>{
    50: Color(0xff138eac), //10%
    100: Color(0xff117e99), //20%
    200: Color(0xff0f6f86), //30%
    300: Color(0xff0d5f73), //40%
    400: Color(0xff0b4f60), //50%
    500: Color(0xff083f4c), //60%
    600: Color(0xff062f39), //70%
    700: Color(0xff062f39), //80%
    800: Color(0xff021013), //90%
    900: Color(0xff000000), //100%
  },
);
