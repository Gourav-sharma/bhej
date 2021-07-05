import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUserModel{
  String chatId="";
  String user_name="";
  String bio="";
  String user_phone="";
  String user_id="";
  String sendr_id="";
  String user_image="";
  String lastMessage="";
  bool isPhoto=false;
  List isTyping=<dynamic>[];

  List group_members=<dynamic>[];
  bool seen=false;
  int unreadMsgCount=0;
  bool online=false;
  Timestamp? timestamp = null;
  String device_token="";

  ChatUserModel({
    chatId,
    sendr_id,
    group_members,
    lastMessage,
    isPhoto,
    isTyping,
    timestamp,
    device_token,
  }){
    this.chatId = chatId;
    this.sendr_id = sendr_id;
    this.group_members = group_members;
    this.lastMessage = lastMessage;
    this.isPhoto = isPhoto;
    this.isTyping = isTyping;
    this.timestamp = timestamp;
    this.device_token = device_token;
  }

  factory ChatUserModel.fromJson(Map<String, dynamic> json){
    return ChatUserModel(
      chatId : json['chatId'],
      sendr_id : json['sender_id'],
      group_members : json['group_members'],
      lastMessage : json['lastMessage'],
      isPhoto : json['isPhoto'],
      isTyping : json['isTyping'],
      timestamp : json['timestamp'],
      device_token : json['device_token'],
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