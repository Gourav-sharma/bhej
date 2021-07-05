
import 'package:flutter/material.dart';
import 'package:bhej/components/ColorResource.dart';


const MaterialColor primarySwatch = const MaterialColor(
  0xff0093b4,
  const <int, Color>{
    50: ColorResource.themeColor,
    100: ColorResource.themeColor,
    200: ColorResource.themeColor,
    300: ColorResource.themeColor,
    400: ColorResource.themeColor,
    500: ColorResource.themeColor,
    600: ColorResource.themeColor,
    700: ColorResource.themeColor,
    800: ColorResource.themeColor,
    900: ColorResource.themeColor,
  },
);

Color primaryColor = ColorResource.themeColor;
Color accentColor = ColorResource.themeColor;
Color buttonColor = Colors.grey[50]!;
Color secondaryHeaderColor = Colors.grey[700]!;
Color canvasColor = Colors.grey[50]!;
Color dividerColor = Colors.white54;
Color scaffoldBackgroundColor = Colors.white;
Color whiteThemeColor = Colors.white;
Color backgroundColor = Color(0xFFE5E5E5);


final lightThemes = ThemeData(
  primarySwatch: primarySwatch,
  primaryColor: primaryColor,
  accentColor: accentColor,
  brightness: Brightness.light,
  backgroundColor: backgroundColor,
  accentIconTheme: IconThemeData(color: whiteThemeColor),
  dividerColor: dividerColor,
  canvasColor: canvasColor,
  scaffoldBackgroundColor: scaffoldBackgroundColor,
  bottomAppBarColor: whiteThemeColor,
  cardColor: whiteThemeColor,
  buttonColor: buttonColor,
  buttonTheme: ButtonThemeData(
    //buttonColor: ColorResource.buttonColor,
    buttonColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
  ),

  secondaryHeaderColor: secondaryHeaderColor,
  indicatorColor: accentColor,
  fontFamily: FontResource.FONT_POPPINES,
  textTheme: TextTheme(
    subtitle1: TextStyle(fontSize: 14, color: ColorResource.black_text),
    headline1: TextStyle(fontSize: 40, color: ColorResource.black_text, fontWeight: FontWeight.w700),
    headline2: TextStyle(fontSize: 35, color: ColorResource.black_text, fontWeight: FontWeight.w700),
    headline3: TextStyle(fontSize: 28, color: ColorResource.black_text, fontWeight: FontWeight.w500),
    headline4: TextStyle(fontSize: 22, color: ColorResource.black_text, fontWeight: FontWeight.w500),
    headline5: TextStyle(fontSize: 18, color: ColorResource.black_text),
    headline6: TextStyle(fontSize: 15, color: ColorResource.black_text),

      bodyText1: TextStyle(fontSize: 13,fontFamily: FontResource.FONT_POPPINES,color: ColorResource.black_text),
      bodyText2: TextStyle(fontSize: 13,fontFamily: FontResource.FONT_HELVETICANEUE,color: ColorResource.black_text),
      button: TextStyle(fontSize: 14, color: Colors.redAccent)

/*    subtitle2: TextStyle(fontSize: 14, color: Colors.redAccent),
    caption:  TextStyle(fontSize: 14, color: Colors.redAccent),
    overline: TextStyle(fontSize: 14, color: Colors.redAccent),
   button: TextStyle(fontSize: 14, color: Colors.redAccent),
    ,*/
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: false,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    hintStyle: TextStyle(fontSize: 20),
    labelStyle: TextStyle(fontSize: 20,color: ColorResource.black_text)
  ),
  iconTheme: IconThemeData(color: Colors.black),
  appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(title: TextStyle(color: ColorResource.green, fontSize: 20,
           fontFamily: FontResource.FONT_HELVETICANEUE))),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),

);
