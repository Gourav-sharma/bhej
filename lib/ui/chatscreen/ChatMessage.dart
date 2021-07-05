import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ChatMessage{
  String message_id="";
  String chat_id="";
  bool showProgress=false;
  String message="";
  String sender_id="";
  String seenstatus="";
  String image="";
  String image_thumbnail="";
  String self_thumbnail="";
  String other_thumbnail="";
  String other_downloaded_image="";
  bool isShow=false;
  bool isImage=false;
  Timestamp? timestamp = null;


  ChatMessage({message, sender_id,seenstatus,image,image_thumbnail,self_thumbnail,
    other_thumbnail,other_downloaded_image,isShow,isImage,timestamp}){
    this.message = message;
    this.sender_id = sender_id;
    this.seenstatus = seenstatus;
    this.image = image;
    this.image_thumbnail = image_thumbnail;
    this.self_thumbnail = self_thumbnail;
    this.other_thumbnail = other_thumbnail;
    this.other_downloaded_image = other_downloaded_image;
    this.isShow = isShow;
    this.isImage = isImage;
    this.timestamp = timestamp;
  }


  factory ChatMessage.fromJson(Map<String, dynamic> json){
    return ChatMessage(
      message: json['message'],
      sender_id: json['sender_id'],
      seenstatus: json['seenstatus'],
      image: json['image'],
      image_thumbnail: json['image_thumbnail'],
      self_thumbnail: json['self_thumbnail'],
      other_thumbnail: json['other_thumbnail'],
      other_downloaded_image: json['other_downloaded_image'],
      isShow: json['isShow'],
      isImage: json['isImage'],
      timestamp: json['timestamp'],
    );
  }

  /*Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'device_token': device_token,
      'image': image,
    };
  }*/
}