import 'dart:async';

import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/constants/database.dart';
import 'package:bhej/environment/environment.dart';
import 'package:bhej/shared/utils/helper.dart';
import 'package:bhej/ui/Inbox/inboxpage.dart';
import 'package:bhej/ui/Login/login.dart';
import 'package:bhej/ui/chatscreen/ChatActivity.dart';
import 'package:bhej/ui/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import  'package:intl/intl.dart';

import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contacts_service/contacts_service.dart';

class Splash extends StatefulWidget{

  Splash({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashActivity();
  }
}

class SplashActivity extends State<Splash> with TickerProviderStateMixin{

  double? descriptionSize;
  double? bodyWidthSize;
  double? bodyheightSize;
  double? fontSize;
  double? topShapeSize;
  late Future<void> _initializeFlutterFireFuture;

  late AnimationController _controller;
  late Animation<double> _animation;

  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize


      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);


    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError!;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };


  }

  initState() {
    super.initState();
    _initializeFlutterFireFuture = _initializeFlutterFire();
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this, value:0.5);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _controller.forward();


    /*User user = FirebaseAuth.instance.currentUser!;
    Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance.collection("users").doc(user.uid)
        .snapshots(includeMetadataChanges:true);
    _usersStream.listen((result) {
      var data = result.data() as Map<String, dynamic>;
      Timestamp timestamp = data['lastSeenTime'] as Timestamp;
      DateTime now = timestamp.toDate();
      String formattedTime = DateFormat.jm().format(now);
      String formattedDate = DateFormat('dd MMM yyyy').format(now);

      print("timesdate"+formattedDate+"___"+formattedTime);
    });*/


    new Timer(const Duration(milliseconds: 2500), () async {
      String? user = await getUserDataFromSharedPref(SharedPrefConstants.USER_DATA);

      Navigator.pop(context);
      if(user!=null && user.isNotEmpty){
        Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft, child: InboxPage(),));
      }else{
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Login(),));
      }
    });
  }



  Future<String?> getUserDataFromSharedPref(key) async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? user =  await prefs.getString(key);
    return user;
  }


  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      /*setState(() {
        print("homepressResume");
        // ...your code goes here...
      });*/
    }
  }



  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final List<Locale> systemLocales = WidgetsBinding.instance!.window.locales;
    String? isoCountryCode = systemLocales.first.countryCode;
    print('countryCode'+isoCountryCode!);

    Environment.setSecreenHeight(context);
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      descriptionSize =
      sizingInformation.deviceScreenType == DeviceScreenType.mobile
          ? displayWidth(context) * 0.85
          : 450.0;

      bodyWidthSize =
      sizingInformation.deviceScreenType == DeviceScreenType.mobile
          ? widthScrren
          : 550.0;

      bodyWidthSize =
      sizingInformation.deviceScreenType == DeviceScreenType.tablet
          ? widthScrren
          : 550.0;

      bodyheightSize =
      sizingInformation.deviceScreenType == DeviceScreenType.mobile
          ? heightScreen
          : heightScreen;

      topShapeSize =
      sizingInformation.deviceScreenType == DeviceScreenType.mobile
          ? displayHeight(context) * 0.10
          : displayHeight(context) * 0.15;

      if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
        fontSize = 18;
      } else if (sizingInformation.deviceScreenType ==
          DeviceScreenType.tablet) {
        fontSize = 18;
      } else if (sizingInformation.deviceScreenType ==
          DeviceScreenType.desktop) {
        fontSize = 20;
      }

      return Scaffold(
          body: SafeArea(
            top: false,
            child: Container(
                height: bodyheightSize,
                width: double.infinity,
                color: ColorResource.white,
                //child : BouncingBallDemo()
                child: ScaleTransition(
                    scale: _animation,
                    child: Container(
                        child : Column(
                          mainAxisAlignment : MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text("Bhej", style: TextStyle(color: ColorResource.toolbar_color , fontSize: 30,fontWeight: FontWeight.bold),),
                            ),
                            Container(
                              child: Text("Instant messaging app", style: TextStyle(color: ColorResource.toolbar_color , fontSize: fontSize),),
                            ),

                          ],
                        )

                    )
                )

            ),
          )
      );
    });
  }
}





