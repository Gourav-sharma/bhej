
import 'dart:io';

import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/ui/chatscreen/ChatActivity.dart';
import 'package:bhej/ui/chatscreen/ChatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Img;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:path_provider/path_provider.dart';
import  'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatItemSelf {
  ChatMessage? chatMessage = null;
  AnimationController? controller=null;
  int? position=null;
  bool? showBubble=null;
  ChatActivityState? activity=null;
  bool isImageError = false;
  String name = "";
  ChatItemSelf(chatmsg,context,controller,position,showBubble,  name) {
    this.chatMessage = chatmsg;
    this.controller = controller;
    this.position = position;
    this.showBubble = showBubble;
    this.activity = context as ChatActivityState;
    this.name = name;

    isImageError = false;
  }

  Widget ChatItem(){
    return Container(
      alignment: Alignment.topRight,
      child : Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
              visible: showBubble!,
              child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 2),
                  child: Container(
                    padding: EdgeInsets.all(5),
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
            margin: EdgeInsets.fromLTRB(100, 7, 10, 7),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: ColorResource.toolbar_color,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5),bottomLeft: Radius.circular(5))
            ),

            child: (!chatMessage!.isImage)?
            Container(
                padding: EdgeInsets.all(8),
                child: checkMessageType(chatMessage!.message)):
            Container(
              width: 200,
              height: 200,
              child: LoadingOverlay(
                isLoading: chatMessage!.showProgress,
                child: Container(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          if(!isImageError){
                            activity!.navigateToLargeImage(chatMessage!.self_thumbnail,name);
                          }
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.file(
                              File(chatMessage!.self_thumbnail),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder:(context, error, stackTrace) {
                                isImageError = true;
                                return  Container(
                                    width: 200,
                                    height: 200,
                                    alignment: Alignment.center,
                                    child : Stack(
                                      alignment: Alignment.center,
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
                                        ),
                                        InkWell(
                                          onTap: (){
                                            activity!.downloadForSelfCache(chatMessage!,position);
                                          },
                                          child: Image.asset(
                                            'assets/images/download_icn.png',
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      ],
                                    )
                                );
                              },
                            )
                        ),
                      ),

                      Visibility(
                        visible: !chatMessage!.isShow,
                        child: Container(
                            width: 200,
                            height: 200,
                            color: ColorResource.transparent_white,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            child: LoadingOverlay(
                              isLoading: true,
                              child: Container(
                                width: 200,
                                height: 200,
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.only(bottom: 40),
                                child: Text('Sending', style: TextStyle(color: ColorResource.toolbar_color , fontSize: 16),),
                              ),
                            )
                        ),
                      ),
                    ],

                  ),
                ),
              ),
            )
            ,
          ),
          Container(
              margin: EdgeInsets.fromLTRB(100, 0, 10, 0),
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(3),
              child: Text(getMessageTime(chatMessage!.timestamp), style: TextStyle(color: ColorResource.black_text , fontSize: 10),)
          )
        ],
      ),
    );
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

  bool _isPhone(String input) {
    final matcher = new RegExp("[1-10-9]");
    return matcher.hasMatch(input);
  }

  bool _isLink(String input) {
    final matcher = new RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
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

