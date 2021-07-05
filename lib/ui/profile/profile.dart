



import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/environment/environment.dart';
import 'package:bhej/shared/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ProfilePage extends StatefulWidget{

  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showProgressBar = false;
  final formKey = new GlobalKey<FormState>();
  double? descriptionSize;
  double? bodyWidthSize;
  double? bodyheightSize;
  double? fontSize;
  double? topShapeSize;

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
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: ColorResource.toolbar_color,
                  title: Text("Profile",
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
              ),
            )
          /**/
        ),
      );
    });
  }

 Widget MobileView() {

    return Container(
      margin: EdgeInsets.all(10),
      width: descriptionSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Stack(
            children: [
            Container(
            width: 150,
            height: 150,
             child: ClipOval(
                child:Image.asset('assets/images/no_img.png',fit: BoxFit.fill,)
              )
          ),

          Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.only(top: 100.0,left: 80.0),
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
            color: ColorResource.toolbar_color,
            shape: BoxShape.circle
        ),

      ),
              Container(
                width: 25,
                margin: EdgeInsets.only(top: 112.0,left: 93.0),
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () => print("click"), // handle your onTap here
                  child: Icon(
                    Icons.camera_alt,
                    size: 25,
                  ),
                ),
              )
            ],
          ),

          Container(
            width: descriptionSize,
            margin: EdgeInsets.only(top:20),
            child: Row(
              children: [
                Container(
                  width:20,
                   child: Icon(
                      Icons.account_circle,
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
                        "Name"
                      ),
                      Container(
                        width: displayWidth(context) * 0.80,
                        child: TextField(
                          decoration: InputDecoration(

                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          Container(
            width: descriptionSize,
            margin: EdgeInsets.only(top:20),
            child: Row(
              children: [
                Container(
                    width:20,
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
                      ),
                      Container(
                        width: displayWidth(context) * 0.80,
                        child: TextField(
                          decoration: InputDecoration(

                            hintText: "Phone",
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )

        ],
      ),

    );

 }

  Widget DesktopView() {

    return Container();

  }
}