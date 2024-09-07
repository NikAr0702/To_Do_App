import 'package:flutter/material.dart';

const Color bluishColor = Color(0xff4e5ae8);
const Color yellowishColor = Color(0xffFFBC76);
const Color pinkColor = Color(0xffFF4667);
const Color white = Colors.white;
const primaryColor = bluishColor;
const Color darkGreyColor = Color(0xff121212);
const Color darkHeaderColor = Color(0xFF424242);
const Color greenColor = Colors.green;

class Themes {
  static final light = ThemeData(
    primaryColor: primaryColor,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    primaryColor: darkGreyColor,
    brightness: Brightness.dark,
  );
}
