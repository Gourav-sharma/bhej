
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name="";
  String phone="";
  String bio="";

  String device_token="";
  String image="";
  String userId="";
  bool online=true;
  Timestamp? lastSeenTime=null;

  String getBio(){
    if(bio==null)
      return "";
    return bio;
  }
  UserModel({name,phone,bio,device_token,image,userId,online,lastSeenTime}){
    this.name = name;
    this.phone = phone;
    this.bio = bio;
    this.device_token = device_token;
    this.image = image;
    this.userId = userId;
    this.online = online;
    this.lastSeenTime = lastSeenTime;
  }

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      name: json['name'],
      phone: json['phone'],
      bio: json['bio'],
      device_token: json['device_token'],
      image: json['image'],
      userId: json['userId'],
      online: json['online'],
      lastSeenTime: json['lastSeenTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'bio': bio,
      'device_token': device_token,
      'image': image,
      'userId': userId,
      'online': online,
      'lastSeenTime': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'bio': bio,
      'device_token': device_token,
      'image': image,
      'userId': userId,
      'online': online,
    };
  }

}