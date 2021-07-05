import 'dart:io';
import 'dart:io' show Platform;

import 'package:bhej/ui/Login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';





/*
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
*/

double widthScrren = 0;
double heightScreen = 0;



/*
const kGoogleApiKey = "AIzaSyCgXtvjiu_iFLtFx0PN4UMreNw3rqFW4bI";
*/






enum AppState {
  free,
  picked,
  cropped,
}

class Environment {
/*
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
*/
  static String Role_Customer = 'Customer';
  static String Role_Consultant = 'Consultant';
  //static String apiUrl = '';
  static String apiUrl = 'https://cdn-api.co-vin.in/api/';
  static bool isAndroid = false;
  static bool isIos = false;
  static bool isWeb = false;
  static String deviceId = '@deviceId';




  static setupDevicePlatform() {
    if (kIsWeb) {
      isWeb = true;
    } else {
      // NOT running on the web! You can check for additional platforms here.
      if (Platform.isAndroid) {
        isAndroid = true;
        // Android-specific code
      } else if (Platform.isIOS) {
        isIos = true;
        // iOS-specific code
      }
    }

  }


  static setSecreenHeight(BuildContext context) {
    widthScrren = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
  }

  static setup() async {
    // Make sure that the binary messenger binding are properly initialiazed
    WidgetsFlutterBinding.ensureInitialized();

    // lock orientation position
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    // transparent status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    setupDevicePlatform();
  }




 static showLoginAlertDialog(BuildContext context) {

    // Create button
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () =>  moveLogin(context));

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Please Login First To Use This Feature In LetsHomeShare."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  static moveLogin(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop();

  }


  static showValidationAlertDialog(BuildContext context, String s) {

    // Create button
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () =>  Navigator.of(context, rootNavigator: true).pop());

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(s),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


 static showAlertDialog(BuildContext context, String s) {
    /*Navigator.pop(context);*/
    Widget okButton =
    FlatButton(child: Text("Yes"), onPressed: () {
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((pref) {
        pref.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Login(),
          ),
              (route) => false,
        );
        //options.headers[HttpHeaders.authorizationHeader] = 'Bearer ' + pref.getString(SessionManager.TOKEN);
      }).whenComplete(() {});
    });
    Widget noButton = FlatButton(
        child: Text("No"),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop());
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(s),
      actions: [
        okButton,
        noButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}


