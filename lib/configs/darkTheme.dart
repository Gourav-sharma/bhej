import 'package:flutter/material.dart';
import 'package:bhej/components/ColorResource.dart';




const MaterialColor primarySwatch = const MaterialColor(
  0xff0093b4,
  const <int, Color>{
    50: const Color(0xff0093b4),
    100: const Color(0xff0093b4),
    200: const Color(0xff0093b4),
    300: const Color(0xff0093b4),
    400: const Color(0xff0093b4),
    500: const Color(0xff0093b4),
    600: const Color(0xff0093b4),
    700: const Color(0xff0093b4),
    800: const Color(0xff0093b4),
    900: const Color(0xff0093b4),
  },
);
Color primaryColor = Color(0xff0093b4);
Color accentColor = Color(0xff0093b4);
Color buttonColor = Colors.grey[50]!;
Color secondaryHeaderColor = Colors.grey[700]!;
Color canvasColor = Colors.grey[50]!;
Color dividerColor = Colors.white54;
Color scaffoldBackgroundColor = Colors.transparent;
Color whiteThemeColor = Colors.white;
Color backgroundColor = Color(0xFFE5E5E5);

final darkThemes = ThemeData(
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
  buttonTheme: ButtonThemeData(),
  toggleButtonsTheme: ToggleButtonsThemeData(),
  secondaryHeaderColor: secondaryHeaderColor,
  indicatorColor: accentColor,
  fontFamily: FontResource.FONT_POPPINES,
  textTheme: TextTheme(),
  primaryTextTheme: TextTheme(),
  accentTextTheme: TextTheme(),
  inputDecorationTheme: InputDecorationTheme(),
  iconTheme: IconThemeData(color: Colors.white),
  primaryIconTheme: IconThemeData(),
  sliderTheme: SliderThemeData(),
  tabBarTheme: TabBarTheme(),
  cardTheme: CardTheme(),
  pageTransitionsTheme: PageTransitionsTheme(),
  appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
       actionsIconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(title: TextStyle(color: ColorResource.themeColor, fontSize: 22, fontWeight: FontWeight.w500))),
  bottomAppBarTheme: BottomAppBarTheme(),
  floatingActionButtonTheme: FloatingActionButtonThemeData(),
  snackBarTheme: SnackBarThemeData(),
  bottomSheetTheme: BottomSheetThemeData(),
  dividerTheme: DividerThemeData(),
  buttonBarTheme: ButtonBarThemeData(),
);
