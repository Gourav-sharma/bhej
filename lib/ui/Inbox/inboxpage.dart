


import 'dart:async';
import 'dart:convert';

import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/components/ImageResource.dart';
import 'package:bhej/constants/database.dart';
import 'package:bhej/environment/environment.dart';
import 'package:bhej/environment/session_manager.dart';
import 'package:bhej/profile/profile.dart';
import 'package:bhej/shared/utils/helper.dart';
import 'package:bhej/ui/Inbox/ChatUserModel.dart';
import 'package:bhej/ui/Login/UserModel.dart';
import 'package:bhej/ui/allusers/AllUsersPage.dart';
import 'package:bhej/ui/chatscreen/ChatActivity.dart';
import 'package:bhej/ui/largeimage/largeimagepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UserContacts.dart';


class InboxPage extends StatefulWidget{

  InboxPage({Key? key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> with WidgetsBindingObserver{

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showProgressBar = false;
  final formKey = new GlobalKey<FormState>();
  double? descriptionSize;
  double? bodyWidthSize;
  double? bodyheightSize;
  double? fontSize;
  double? topShapeSize;
  int? _tabIndex = 0;
  int? tab_length = 2;
  var list = <ChatUserModel>[];
  User user = FirebaseAuth.instance.currentUser!;
  UserModel? myDetail = null;
  List<UserContact> contactList = <UserContact>[];
  List<String> contactNumList = <String>[];
  late StreamSubscription<QuerySnapshot> onlineListner;
  late StreamSubscription<QuerySnapshot> chatUsersListner;
  @override
  void initState() {
    super.initState();
    updateOnlineStatus(true);
    WidgetsBinding.instance!.addObserver(this);
    getMyData();

  }

  @override
  void dispose() {
    onlineListner.cancel();
    chatUsersListner.cancel();
    print("AppLifecyclee__dispose");
    super.dispose();

  }

  Future<bool> _onWillPop() async {
    updateOnlineStatus(false);
    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("AppLifecyclee__resumed");
    if(state == AppLifecycleState.resumed){
      print("AppLifecyclee__resumed");
      updateOnlineStatus(true);

    }
    if(state == AppLifecycleState.paused){
      print("AppLifecyclee__paused");
      updateOnlineStatus(false);

    }
    if(state == AppLifecycleState.detached){
      print("AppLifecyclee__detached");
      updateOnlineStatus(false);
    }
    if(state == AppLifecycleState.inactive){
      print("AppLifecyclee__inactive");
    }
  }

  updateOnlineStatus(bool isResume) async {
    if(isResume) {
      Map<String,dynamic> map = {'online':  true};
      await FirebaseFirestore.instance.collection("users").doc(
          user.uid).update(map);
    }else{
      Map<String,dynamic> map = {'online':  false , 'lastSeenTime':FieldValue.serverTimestamp()};
      await FirebaseFirestore.instance.collection("users").doc(
          user.uid).update(map);
    }
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

      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: ColorResource.white,
          body: SafeArea(
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: ColorResource.toolbar_color,
                    title: Text("Bhej",
                      style: TextStyle(
                          color: ColorResource.white
                      ),),
                    bottom: TabBar(
                      labelStyle: TextStyle(fontSize: fontSize),
                      tabs: [
                        Tab( text: "Chats"),
                        Tab( text: "Status"),
                       // Tab( text: "Calls")
                      ],
                    ),
                    actions: [
                      //list if widget in appbar actions
                      PopupMenuButton(
                        //don't specify icon if you want 3 dot menu
                        color: ColorResource.toolbar_color,
                        itemBuilder: (context) => [
                          PopupMenuItem<int>(
                            value: 0,
                            child: Text("Profile",style: TextStyle(color: Colors.white),),
                          ),
                        ],
                        onSelected: (item) => {SelectedItem(context, item!)},
                      ),
                    ],
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
        ),
      );
    });
  }

  SelectedItem(BuildContext context, Object item) {

    switch (item) {
      case 0:
        Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft, child: ProfilePage(),));
        break;
    }
  }

  Widget  MobileView() {
    return Scaffold(
      body:  Container(
        child: Column(
          children: [
            Expanded(child: Container(
              width: descriptionSize,
              child: TabBarView(
                children: [
                  Container(
                    width: descriptionSize,
                    child: Stack(
                      children: [
                        Container(
                          child: ListView.builder(
                              physics: ScrollPhysics(),
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, int index){
                                return ChatUserListItem(index);
                              }),
                        ),


                        Container(
                          width: descriptionSize,
                          height: displayHeight(context) * 0.80,
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                              onPressed: () {
                                checkContactPermission();
                              },
                              child: Icon(Icons.chat),
                              backgroundColor: ColorResource.toolbar_color,
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                  Container(
                      width: descriptionSize,
                      child: Stack(
                        children: [
                          Container(
                            child: Center(
                              child: Text(
                                  "No Record Found"
                              ),
                            ),
                          ),

                          Container(
                            width: descriptionSize,
                            height: displayHeight(context) * 0.80,
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FloatingActionButton(
                                      onPressed: () {

                                      },
                                      child: Icon(Icons.edit),
                                      backgroundColor: ColorResource.gray,
                                    ),

                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: FloatingActionButton(
                                        onPressed: () {

                                        },
                                        child: Icon(Icons.camera),
                                        backgroundColor: ColorResource.toolbar_color,
                                      ),
                                    )

                                  ],
                                )
                            ),
                          )

                        ],
                      )
                  ),
                  /*Container(
                    width: descriptionSize,
                    child: Stack(
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                                "No Record Found"
                            ),
                          ),
                        ),

                        Container(
                          width: descriptionSize,
                          height: displayHeight(context) * 0.80,
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 20),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                              onPressed: () {

                              },
                              child: Icon(Icons.add_call),
                              backgroundColor: ColorResource.toolbar_color,
                            ),
                          ),
                        )

                      ],
                    ),
                  )*/
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget ChatUserListItem(int pos){
    return InkWell(
      onTap: (){
        navigateToChatPage(list[pos]);
      },
      child: Container(
        width: descriptionSize,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    padding: EdgeInsets.zero,
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorResource.gray,
                    ),
                    child: InkWell(
                      onTap: (){
                        if(list[pos].user_image!=null && list[pos].user_image.isNotEmpty){
                          navigateToLargeImage(list[pos]);
                        }
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: Image.network(
                            list[pos].user_image,
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

                Visibility(
                  visible: (list[pos].online==true)?true:false,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(right: 5,bottom: 3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(ImageResource.icn_active,
                          height: 15,
                          width: 15,
                          fit:BoxFit.fill),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: [
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(list[pos].user_name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)

                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin:EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child:
                                  (list[pos].isPhoto)?
                                  Container(
                                      child: ((list[pos].isTyping.isNotEmpty))?
                                      Text('typing...',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: (TextStyle(color: ColorResource.green2)),)
                                          :
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(Icons.image,size: 16,
                                            color: ColorResource.gray,),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text('Photo',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: (TextStyle(color: ColorResource.black_text)),),
                                            ),
                                          )
                                        ],
                                      )
                                  ):
                                  Text(
                                    (list[pos].isTyping.isEmpty)
                                        ?
                                    list[pos].lastMessage
                                        :'typing...'
                                    ,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: (TextStyle(color: (list[pos].isTyping.isEmpty)
                                        ?ColorResource.black_text
                                        :ColorResource.green2)),
                                  )
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: ColorResource.gray.withOpacity(0.5)
                                  ),
                                )),
                          ),
                        ],
                      )
                  ),
                  Visibility(
                    visible: (list[pos].unreadMsgCount==0)?false:true,
                    child: Container(
                        alignment: Alignment.center,
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: ColorResource.toolbar_color
                        ),
                        child: Text(list[pos].unreadMsgCount.toString(),style: TextStyle(fontSize: 12,color: ColorResource.white),)
                    ),
                  ),
                ],

              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget  DesktopView() {
    return Container();
  }

  getChatUsers(){
    Stream<QuerySnapshot> _chatRoomStream = FirebaseFirestore.instance.collection("chat-messages")
        .where('group_members',arrayContains: {'phone':user.phoneNumber,'id':user.uid})
        .snapshots(includeMetadataChanges:false);
    chatUsersListner =  _chatRoomStream.listen((event) async {

      contactList.clear();
      contactNumList.clear();

      String? contacts = await getUserDataFromSharedPref(SessionManager.USER_CONTACTS);
      if(contacts!=null && contacts.isNotEmpty) {
        contactList = UserContact.decode(contacts);
        for(int i=0;i<contactList.length;i++){
          contactNumList.add(contactList[i].phone);
        }
      }

      print("hfhfhfhf"+event.docs.length.toString());
      list.clear();
      event.docs.forEach((result) async {
        var data = result.data() as Map<String, dynamic>;

        ChatUserModel model = ChatUserModel.fromJson(data);


        int unreadMsgCount = 0;
        int readMessglenth = 0;
        /*QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chat-messages").doc(
            model.chatId).collection('messages').get();*/


        if(data['messageLength']!=null){
          int msgLength = data['messageLength'];

          Map<String,dynamic> unreadMap = data['readMsgCount'];
          if(unreadMap[user.uid]!=null) {
            readMessglenth = unreadMap[user.uid]!;
          }
          unreadMsgCount = msgLength-readMessglenth;
        }

        print("msgLength"+unreadMsgCount.toString());
        model.unreadMsgCount = unreadMsgCount;

        for(int i=0;i<model.group_members.length;i++){
          Map<String,dynamic> map = model.group_members[i];

          if(map['id'].toString()!=user.uid){
            model.user_id = map['id'].toString();
            model.user_phone = map['phone'].toString();
            int indx = contactNumList.indexOf(model.user_phone);
            if(indx>-1){
              model.user_name = contactList[indx].name;
            }else{
              model.user_name = model.user_phone;
            }
            break;
          }
        }


        list.add(model);

        /*for(int i=0;i<contactList.length;i++){
          // print(contactList[i].phone+'__'+model.user_phone);
          if(contactList[i].phone==model.user_phone){
            model.user_name = contactList[i].name;
            break;
          }
        }*/

        /*Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance.collection("users").doc(otherUserId)
            .snapshots(includeMetadataChanges:true);
         _usersStream.listen((result) {
           var data = result.data() as Map<String, dynamic>;
           UserModel userModel = UserModel.fromJson(data);
           model.user_image= userModel.image;
           model.user_phone= userModel.phone;
           model.user_name= userModel.phone;
           model.bio= userModel.bio;
           model.user_id= userModel.userId;
           model.online= userModel.online;

           for(int i=0;i<contactList.length;i++){
             // print(contactList[i].phone+'__'+model.user_phone);
             if(contactList[i].phone==model.user_phone){
               model.user_name = contactList[i].name;
               break;
             }
           }

           setState(() {
             list;
           });

        });*/

        setState(() {
          list;
        });


        //UserModel userModel = new UserModel(name:result.data()["name"],phone:result.data()["phone"],device_token:result.data()["device_token"],image:result.data()["image"]);
        /*ChatUserModel model = ChatUserModel.fromJson(data);

        //print("contactList"+contactList.length.toString());
        for(int i=0;i<contactList.length;i++){
         // print(contactList[i].phone+'__'+model.user_phone);
          if(contactList[i].phone==model.user_phone){
            model.contact_name = contactList[i].name;
            break;
          }
        }
        list.add(model);
        setState(() {
          list;
        });*/
      });


      if(list.isNotEmpty){
        addOnlineLisners();
      }

    });
  }

  addOnlineLisners(){
    Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection("users")
        .snapshots(includeMetadataChanges:false);
    onlineListner =  _usersStream.listen((event) {
      event.docs.forEach((result) {
        var data = result.data() as Map<String, dynamic>;

        //UserModel userModel = new UserModel(name:result.data()["name"],phone:result.data()["phone"],device_token:result.data()["device_token"],image:result.data()["image"]);
        UserModel model = UserModel.fromJson(data);
        for(ChatUserModel chatUser in list){
          if(chatUser.user_id==model.userId){
            setState(() {
              chatUser.online = model.online;
              chatUser.user_image= model.image;
              chatUser.user_phone= model.phone;
              chatUser.bio= model.bio;
              chatUser.user_id= model.userId;

            });
          }
        }
      });

    });

  }

  navigateToChatPage(ChatUserModel friendModel){
    UserModel userModel = new UserModel(name: friendModel.user_name , phone: friendModel.user_phone ,bio: friendModel.bio , device_token: "",image: friendModel.user_image,userId: friendModel.user_id,online: friendModel.online);
    Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft, child: ChatActivity(userModel,friendModel.chatId),));
  }

  navigateToLargeImage(ChatUserModel friendModel){
    Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft, child: LargeImagePage(friendModel.user_image,friendModel.user_name),));
  }

  getMyData() async {
    String? user = await getUserDataFromSharedPref(SharedPrefConstants.USER_DATA);
    Map<String, dynamic> userMap = jsonDecode(user);
    myDetail = UserModel.fromJson(userMap);

    getChatUsers();

  }



  Future<String> getUserDataFromSharedPref(key) async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? user =  await prefs.getString(key);
    if(user==null)
      return '';
    return user;
  }


  Future<bool> checkContactPermission() async {
    if (await Permission.contacts.request().isGranted ) {
      navigateContactPage();
      // Either the permission was already granted before or the user just granted it.
    } else {
      Map<Permission, PermissionStatus> statuses = await [Permission.contacts,].request();
      print(statuses);
      if(statuses[Permission.contacts]==PermissionStatus.permanentlyDenied){
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
        navigateContactPage();
      }
    }
    return false;
  }


  navigateContactPage(){
    Navigator.push(context,PageTransition(
      type: PageTransitionType.rightToLeft,
      child: AllUsersPage(),
    ),
    );
  }



}