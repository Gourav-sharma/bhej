

import 'dart:async';
import 'dart:convert';

import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/components/ImageResource.dart';
import 'package:bhej/environment/environment.dart';
import 'package:bhej/environment/session_manager.dart';
import 'package:bhej/shared/utils/helper.dart';
import 'package:bhej/ui/Login/UserModel.dart';
import 'package:bhej/ui/allusers/UserListItem.dart';
import 'package:bhej/ui/chatscreen/ChatActivity.dart';
import 'package:bhej/ui/chatscreen/ChatItemOther.dart';
import 'package:bhej/ui/chatscreen/ChatItemSelf.dart';
import 'package:bhej/ui/chatscreen/ChatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UserContacts.dart';

class AllUsersPage extends StatefulWidget{

  AllUsersPage({Key? key}) : super(key: key);

  @override
  AllUsersPageState createState() => AllUsersPageState();
}

class AllUsersPageState extends State<AllUsersPage> with SingleTickerProviderStateMixin {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  double? descriptionSize;
  double? bodyWidthSize;
  double? bodyheightSize;
  double? fontSize;
  double? topShapeSize;
  TextEditingController enterMsgController = new TextEditingController();
  var list = <UserModel>[];
  User user = FirebaseAuth.instance.currentUser!;
  late AllUsersPageState pageState;
  late StreamSubscription<QuerySnapshot> _usersListner;
  List<UserContact> contactList = <UserContact>[];
  List<String> contactNumList = <String>[];
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );


    checkContactPermission();
    pageState = this;
    super.initState();
  }


  @override
  void dispose() {
    _controller.dispose();
    _usersListner.cancel();
  }

  naviGatePage(firendModel){
    //Navigator.pop(context);
    Navigator.pushReplacement(context,PageTransition(type: PageTransitionType.rightToLeft, child: ChatActivity(firendModel,null),));
  }
  @override
  Widget build(BuildContext context) {

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
        backgroundColor: ColorResource.white,

        body: SafeArea(
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
        ),
      );
    });
  }

  Widget  MobileView() {
    return Container(
      alignment: Alignment.topLeft,
      color: ColorResource.white,
      child: Column(
        children: [
          Material(
            elevation: 10,
            child: Container(
              height: 60,
              color: ColorResource.toolbar_color,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Text("Bhej-Instant messaging app", style: TextStyle(color: ColorResource.white , fontSize: fontSize),),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      _controller.repeat();
                      checkContactPermission();
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10,top: 5),
                      padding: EdgeInsets.all(5),
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                        child: Image.asset(
                          'assets/images/refresh_icn.png',
                          fit: BoxFit.fitWidth,
                          height: 22,
                          width: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                color: ColorResource.white,
                child:  Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new UserListItem(list[index],context,pageState).ListItem();
                      }),
                ),
              )
          ),

        ],

      ),

    );
  }

  getAllUsers(){

    Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection("users").snapshots(includeMetadataChanges:false);
    _usersListner = _usersStream.listen((event) {
      list.clear();
      event.docs.forEach((result) {
        var data = result.data() as Map<String, dynamic>;
        //UserModel userModel = new UserModel(name:result.data()["name"],phone:result.data()["phone"],device_token:result.data()["device_token"],image:result.data()["image"]);
        UserModel userModel = UserModel.fromJson(data);
        if(user.phoneNumber!=userModel.phone) {

          if(contactNumList.contains(userModel.phone)){
            int indx = contactNumList.indexOf(userModel.phone);
            userModel.name = contactList[indx].name;
            list.add(userModel);
            //break;
          }

          /*for(int i=0;i<contactList.length;i++){
            // print(contactList[i].phone+'__'+model.user_phone);

          }*/
        }
      });

      setState(() {
        _controller.stop(canceled: true);
        list;
      });

    });
  }

  Widget  DesktopView() {
    return Container();
  }


  /*getMyData() async {
    contactList.clear();
    String? contacts = await getUserDataFromSharedPref(SessionManager.USER_CONTACTS);

    if(contacts!=null && contacts.isNotEmpty) {

      contactList = UserContact.decode(contacts);
      getAllUsers();
    }
    else{
      checkContactPermission();
    }



  }*/

  Future<String> getUserDataFromSharedPref(key) async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? user =  await prefs.getString(key);
    if(user==null)
      return '';
    return user;
  }


  Future<bool> checkContactPermission() async {
    if (await Permission.contacts.request().isGranted ) {
      _fetchContacts();
      // Either the permission was already granted before or the user just granted it.
    } else {
      Map<Permission, PermissionStatus> statuses = await [Permission.contacts,].request();
      print(statuses);
      if(statuses[Permission.contacts]==PermissionStatus.permanentlyDenied){
        _controller.stop(canceled: true);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Permission Denied"),
                content:  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 10),
                    child: Text("You have denied contact permission permanantly,Please go to seetings and allow to get your contacts in bhej", style: TextStyle(color: ColorResource.black_text , fontSize: 16),)),
                actions: <Widget>[
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 10),
                        child: Text("Cancel", style: TextStyle(color: ColorResource.google_red , fontSize: 16),)),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      openAppSettings();
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 10),
                        child: Text("Go to settings", style: TextStyle(color: ColorResource.google_red , fontSize: 16),)),
                  )
                ],
              );
            }
        );

        //print("got to settings");
      }else if(PermissionStatus==Permission.contacts.request().isGranted){
        _fetchContacts();
      }
    }
    return false;
  }

  _fetchContacts() async {
    /**/
    contactList.clear();
    contactNumList.clear();
    _controller.repeat();
    Iterable<Contact> contacts = await ContactsService.getContacts();
    for(int i=0;i<contacts.length;i++){
      Contact contact = contacts.elementAt(i);
      String cname = contact.displayName!;
      if(contact.phones!.length>0){
        String number = contact.phones!.elementAt(0).value!;
        number = number.replaceAll(' ', '');
        if(!number.startsWith('+91')){
          number = '+91'+number;
        }

        UserContact userContact = new UserContact(name: cname, phone: number);
        print("contactDetail__"+userContact.phone+'___'+userContact.name);
        contactList.add(userContact);
        contactNumList.add(number);
      }

    }

    final String encodedData = UserContact.encode(contactList);

    final prefs = await SharedPreferences.getInstance();
    var success = await prefs.setString(SessionManager.USER_CONTACTS, encodedData);

    if(success){
      getAllUsers();
    }
  }
}



