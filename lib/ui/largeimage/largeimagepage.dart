

import 'dart:io';

import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/environment/environment.dart';
import 'package:bhej/shared/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zoom_widget/zoom_widget.dart';

class LargeImagePage extends StatefulWidget{

  String? data;
  String? name;

  LargeImagePage(this.data, this.name, {Key? key}) : super(key: key);

  @override
  _LargeImagePageState createState() => _LargeImagePageState();
}

class _LargeImagePageState extends State<LargeImagePage>{

  double? descriptionSize;
  double? logoheight;
  double? logoWidth;
  double? bodyWidthSize;
  double? bodyheightSize;
  double? topShapeSize;
  double  titleSize = 18;
  double? fontSize;
  double? loginTitleSize;
  bool showProgressBar = false;

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    Environment.setSecreenHeight(context);
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      descriptionSize =
      sizingInformation.deviceScreenType == DeviceScreenType.mobile
          ? displayWidth(context) * 0.90
          : 425.0;

      logoheight = sizingInformation.deviceScreenType == DeviceScreenType.mobile
          ? 150.0
          : 250.0;

      logoWidth = sizingInformation.deviceScreenType == DeviceScreenType.mobile
          ? 150.0
          : 250.0;

      topShapeSize =
      sizingInformation.deviceScreenType == DeviceScreenType.mobile
          ? displayHeight(context) * 0.15
          : displayHeight(context) * 0.15;

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

      if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
        fontSize = 16;
      } else if (sizingInformation.deviceScreenType ==
          DeviceScreenType.tablet) {
        fontSize = 18;
      } else if (sizingInformation.deviceScreenType ==
          DeviceScreenType.desktop) {
        fontSize = 20;
      }

      loginTitleSize =
      sizingInformation.deviceScreenType == DeviceScreenType.mobile
          ? 20
          : 22;
      return Scaffold(

        body: LoadingOverlay(
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
        ),
      );
    });
  }

  Widget MobileView() {
    return  Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                height: topShapeSize,
                child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: [
                        Positioned(left: 0,top: 20, child:Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back,color: Colors.white,),
                            onPressed: () => Navigator.pop(context),
                          ),
                        )),
                        Positioned(left: 50,top: 35,
                            child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          alignment: Alignment.center,
                          child: Text(widget.name!,style: TextStyle(
                              color: Colors.white,fontSize:18
                          ),),
                        )
                        )

                      ],
                    )
                ),
              ),
              Expanded(
                  child:Container(
                    width: descriptionSize,
                    alignment: Alignment.topCenter,
                    child: chatUI(),
                  ),)

            ],
          ),
        );
  }

  Widget DesktopView() {
    return Container(
      width: widthScrren,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.all(0.0),
      color: ColorResource.black_text,
      child: Column(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            height: topShapeSize,
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Positioned(left: 0,top: 20, child:Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.clear,color: Colors.white,),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )),

                  ],
                )
            ),
          ),
          Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    width: descriptionSize,
                    alignment: Alignment.center,
                    child: chatUI(),
                  ),
                ],
              )),

        ],
      ),
    );
  }

  Widget chatUI() {

    return Container(
        width: descriptionSize,
        height: heightScreen,
        alignment: Alignment.topCenter,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Zoom(
                  maxZoomWidth: 500,
                  maxZoomHeight: 500,
                  doubleTapZoom: true,
                  initZoom: 0.0,
                  backgroundColor: Colors.transparent,
                  child: (widget.data!.startsWith('http://'))?
                  Image.network(
                    widget.data!,
                    fit: BoxFit.fill,
                  ):
                  Image.file(
                    File(widget.data!),
                    fit: BoxFit.fill,
                  ),
                )
            )

          ],
        )
    );



  }





}











