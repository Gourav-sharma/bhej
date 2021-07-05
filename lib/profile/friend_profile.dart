
import 'dart:async';
import 'dart:io';

import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/environment/environment.dart';
import 'package:bhej/shared/utils/helper.dart';
import 'package:bhej/ui/largeimage/largeimagepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';


class FriendProfilePage extends StatefulWidget{

  String userId = "";
  String userMobileName = "";
  FriendProfilePage(this.userId,this.userMobileName,{Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<FriendProfilePage> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showProgressBar = false;
  final formKey = new GlobalKey<FormState>();
  double? descriptionSize;
  double? bodyWidthSize;
  double? bodyheightSize;
  double? fontSize;
  double? topShapeSize;
  String userImage = "";
  String userName = "";
  String userMobile = "";
  String userbio = "";
  final picker = ImagePicker();
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  late StreamSubscription<DocumentSnapshot> _userListner;

  @override
  void initState() {

    getUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Environment.setSecreenHeight(context);
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      descriptionSize =
      sizingInformation.deviceScreenType == DeviceScreenType.mobile
          ? widthScrren
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
        backgroundColor: ColorResource.white,
        key: scaffoldKey,
        body: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: ColorResource.toolbar_color,
                title: Text(widget.userMobileName,
                  style: TextStyle(
                      color: ColorResource.white
                  ),),

              ),
              body:LoadingOverlay(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ScreenTypeLayout(
                          mobile: MobileView(),
                          desktop: DesktopView(),
                        ),
                      )
                    ],
                  ),
                ),
                isLoading: showProgressBar,
              ) ,
            )
          /**/
        ),
      );
    });
  }

  Widget MobileView() {
    return SingleChildScrollView(
      child: Container(
        width: descriptionSize,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 150,
                      height: 150,
                      child: InkWell(
                        onTap: (){
                          if(userImage!=null && userImage.isNotEmpty) {
                            Navigator.push(context, PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: LargeImagePage(userImage,userName),));
                          }
                        },
                        child: ClipOval(
                            child: Image.network(
                              userImage,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return Image.asset(
                                    'assets/images/no_img.png',
                                    fit: BoxFit.fitWidth);
                              },
                            )
                        ),
                      )
                  ),

                  Container(
                    width: descriptionSize,
                    margin: EdgeInsets.only(top:50),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width:20,
                            margin: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.account_circle,
                              size: 25,
                              color: ColorResource.toolbar_color,
                            )
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name"
                                  ,style: TextStyle(color: ColorResource.gray2,fontSize: 14,fontWeight: FontWeight.normal),
                                ),

                                Container(
                                  width: displayWidth(context) * 0.80,
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    userName,
                                    style: TextStyle(color: ColorResource.black_text,fontSize: 14,fontWeight: FontWeight.normal),
                                  ),
                                ),

                                Container(
                                  width: displayWidth(context) * 0.80,
                                  height: 0.5,
                                  margin: EdgeInsets.only(top: 10),
                                  color: ColorResource.gray,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: descriptionSize,
                    margin: EdgeInsets.only(top:20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width:20,
                            margin: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.info_outline,
                              size: 25,
                              color: ColorResource.toolbar_color,
                            )
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "About"
                                  ,style: TextStyle(color: ColorResource.gray2,fontSize: 14,fontWeight: FontWeight.normal),
                                ),
                                Container(
                                  width: displayWidth(context) * 0.80,
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    userbio,
                                    style: TextStyle(color: ColorResource.black_text,fontSize: 14,fontWeight: FontWeight.normal),
                                  ),

                                ),
                                Container(
                                  width: displayWidth(context) * 0.80,
                                  height: 0.5,
                                  margin: EdgeInsets.only(top: 10),
                                  color: ColorResource.gray,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: descriptionSize,
                    margin: EdgeInsets.only(top:20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width:20,
                            margin: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.phone,
                              size: 25,
                              color: ColorResource.toolbar_color,
                            )
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phone"
                                ,style: TextStyle(color: ColorResource.gray2,fontSize: 14,fontWeight: FontWeight.normal),
                              ),
                              Container(
                                width: displayWidth(context) * 0.80,
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  userMobile,
                                  style: TextStyle(color: ColorResource.black_text,fontSize: 14,fontWeight: FontWeight.normal),
                                ),

                              ),
                              Container(
                                width: displayWidth(context) * 0.80,
                                height: 0.5,
                                margin: EdgeInsets.only(top: 10),
                                color: ColorResource.gray,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),

          ],

        ),

      ),
    );

  }




  getUserInfo() async {
    Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .snapshots(includeMetadataChanges:false);
    _userListner = _usersStream.listen((result) async {
      var data = result.data() as Map<String, dynamic>;
      if(data!=null){
        String image = data['image'];
        String name = data['name'];
        String phone = data['phone'];
        String bio = data['bio'];

        print("image"+image);
        setState(() {
          userImage = image;
          userName = name;
          userMobile = phone;
          userbio = bio;
        });
      }
    });
  }

  Widget DesktopView() {

    return Container();

  }
}