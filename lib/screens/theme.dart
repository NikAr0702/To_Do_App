import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishColor = Color(0xff4e5ae8);
const Color yellowishColor = Color(0xffFFBC76);
const Color pinkColor = Color(0xffFF4667);
const Color white = Colors.white;
const primaryColor = bluishColor;
const Color darkGreyColor = Color(0xff121212);
const Color darkHeaderColor = Color(0xFF424242);
const Color greenColor = Colors.green;
const Color orangeColor = Colors.deepOrangeAccent;

class Themes {
  static final light = ThemeData(
    dialogBackgroundColor: Colors.white,
    primaryColor: primaryColor,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    dialogBackgroundColor: darkGreyColor,
    primaryColor: darkGreyColor,
    brightness: Brightness.dark,
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      textStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ));
}
