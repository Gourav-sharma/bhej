
import 'dart:io';

import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/ui/chatscreen/ChatActivity.dart';
import 'package:bhej/ui/chatscreen/ChatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import  'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatItemOther {
  ChatMessage? chatMessage = null;
  ChatActivityState? activity=null;
  int? position=null;
  bool? showBubble=null;
  bool isImageError = false;
  String name = "" ;
  ChatItemOther(chatmsg,context,position,showBubble,  name) {
    print("asdhshdsa");
    this.chatMessage = chatmsg;
    this.position = position;
    this.showBubble = showBubble;
    this.activity = context as ChatActivityState;
    this.name = name;
  }

  Widget ChatItem(){
    return Visibility(
      visible: chatMessage!.isShow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: showBubble!,
              child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(top: 3),
                    decoration: BoxDecoration(
                        color: ColorResource.color_bubble,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Text(
                      getMessageDate(chatMessage!.timestamp),
                      style: TextStyle(color: ColorResource.white , fontSize: 11),
                    ),
                  )
              )
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.fromLTRB(10, 7, 100, 7),
            child : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: ColorResource.white,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5))
                        ),
                        child: (!chatMessage!.isImage)?
                        Container(
                            padding: EdgeInsets.all(8),
                            child: checkMessageType(chatMessage!.message)) :

                        Container(
                          width: 200,
                          height: 200,
                          child: LoadingOverlay(
                            isLoading: chatMessage!.showProgress,
                            child: Container(
                              child: InkWell(
                                onTap: (){
                                  if(!isImageError){
                                    activity!.navigateToLargeImage(chatMessage!.other_downloaded_image,name);
                                  }
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.file(
                                      File(chatMessage!.other_downloaded_image),
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      errorBuilder:(context, error, stackTrace) {
                                        isImageError = true;
                                        return Stack(
                                          alignment: Alignment.center ,
                                          children: [
                                            Container(
                                              child: Stack(
                                                children: [
                                                  Image.network(
                                                    chatMessage!.image,
                                                    width: 200,
                                                    height: 200,
                                                    cacheHeight: 50,
                                                    cacheWidth: 50,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (context, error, stackTrace) {
                                                      return Image.asset(
                                                          'assets/images/no_img.png',
                                                          fit: BoxFit.fitWidth);
                                                    },
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    height: 200,
                                                    color: ColorResource.transparent_black2,
                                                  )
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: (){

                                                activity!.checkPermissionforDownload(chatMessage!,position);
                                              },
                                              child: Image.asset(
                                                'assets/images/download_icn.png',
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          ],

                                        );
                                      },
                                    )
                                ),
                              ),
                            ),
                          ),
                        )
                    ),
                  ],

                ),
                Container(
                    padding: EdgeInsets.all(3),
                    child: Text(getMessageTime(chatMessage!.timestamp), style: TextStyle(color: ColorResource.black_text , fontSize: 11),)
                )
              ],

            ),
          ),
        ],

      ),
    );
  }

  checkPermission() async {
    if (await Permission.storage.request().isGranted) {

    } else {
      Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();

    }
  }
  String getMessageTime(Timestamp? timestamp){
    String currentTime = "";
    if(timestamp!=null) {
      DateTime date = timestamp.toDate();
      currentTime = DateFormat.jm().format(date);
    }
    return currentTime;
  }

  String getMessageDate(Timestamp? timestamp){

    String currentTime = "";
    if(timestamp!=null) {
      DateTime date = timestamp.toDate();
      currentTime = DateFormat('dd/MMM/yyyy').format(date);

      DateTime tDate = DateTime.now();
      String today = DateFormat('dd/MMM/yyyy').format(tDate);

      if (today == currentTime)
        return 'Today';
    }
    return currentTime;

  }

  bool _isLink(String input) {
    final matcher = new RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    return matcher.hasMatch(input);
  }

  bool _isPhone(String input) {
    final matcher = new RegExp("[1-10-9]");
    return matcher.hasMatch(input);
  }

  Widget openandshowlink(String message) {

    return InkWell(
      onTap:() async => await canLaunch(message) ? await launch(message) : throw 'Could not launch $message',
      child: Text(message, style: TextStyle(color: ColorResource.white , fontSize: 14)),
    ) ;
  }

  Widget openCall(String message) {

    return InkWell(
      onTap:() async => await launch(('tel://${message}')),
      child: Text(message, style: TextStyle(color: ColorResource.white , fontSize: 14)),
    ) ;
  }

 Widget checkMessageType(String message) {
    if(_isLink(message)==true){
     return openandshowlink(message);
    }
    if(_isPhone(message)==true){
      return openCall(message);
    }
    else{
      return Text(chatMessage!.message, style: TextStyle(color: ColorResource.white , fontSize: 14));
    }

 }

}