import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

enum SnackBarType { SUCCESS,ERROR }


void showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String value,SnackBarType snackBarType) {
  scaffoldKey.currentState!.showSnackBar(SnackBar(
      backgroundColor: snackBarType ==SnackBarType.SUCCESS?Colors.lightGreen:Colors.red,
      content: Text(value, textAlign: TextAlign.left, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)),
      duration: Duration(seconds: 2)));
}

Size displaySize(BuildContext context) {
  debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}

Route createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    widget,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var curveTween = CurveTween(curve: curve);
      var tween = Tween(begin: begin, end: end).chain(curveTween);
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
          position: offsetAnimation,
          child: child
      );
    },
  );
}




Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}








