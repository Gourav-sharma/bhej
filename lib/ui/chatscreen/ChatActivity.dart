

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/components/ImageResource.dart';
import 'package:bhej/constants/database.dart';
import 'package:bhej/environment/environment.dart';
import 'package:bhej/profile/friend_profile.dart';
import 'package:bhej/shared/utils/helper.dart';
import 'package:bhej/ui/Login/UserModel.dart';
import 'package:bhej/ui/UserContacts.dart';
import 'package:bhej/ui/chatscreen/ChatItemOther.dart';
import 'package:bhej/ui/chatscreen/ChatItemSelf.dart';
import 'package:bhej/ui/chatscreen/ChatMessage.dart';
import 'package:bhej/ui/largeimage/largeimagepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';
import  'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class ChatActivity extends StatefulWidget{
  UserModel? userModel = null;
  String? chatId = null;
  ChatActivity(this.userModel,this.chatId,{Key? key}) : super(key: key);

  @override
  ChatActivityState createState() => ChatActivityState();
}

class ChatActivityState extends State<ChatActivity> with TickerProviderStateMixin{

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  double? descriptionSize;
  double? bodyWidthSize;
  double? bodyheightSize;
  double? fontSize;
  double? topShapeSize;
  TextEditingController enterMsgController = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  var list = <ChatMessage>[];
  var typingList = <dynamic>[];

  User user = FirebaseAuth.instance.currentUser!;
  late UserModel myDetail;

  //var readMessageList = Map<String,dynamic>();

  String lastSeenStatus = "";
  String typingStatus = "";

  late StreamSubscription<DocumentSnapshot> _typelistListner;
  late StreamSubscription<DocumentSnapshot> _onlineListner;
  late StreamSubscription<QuerySnapshot> _chatMsgListner;


  late File _image;
  final picker = ImagePicker();
  late AnimationController controller;
  bool emojiShowing = false;

  int previousMsgLt = 0;
  @override
  void initState() {
    super.initState();
    checkPermissionstorage();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    controller.repeat(reverse: false);
    if(widget.chatId==null){
      getChatId();
    }else{

      getMyData();
      getTypeList();
      getChatMessages();
      addOnlineLisners();
    }

    print("disposeHuanhi");

    /*vy4zPBHPcZqGCgB5uA8P*/
  }


  @override
  void dispose() {
    print("disposeHua");

    if(_chatMsgListner!=null)
      _chatMsgListner.cancel();
    if(_onlineListner!=null)
      _onlineListner.cancel();
    if(_typelistListner!=null)
      _typelistListner.cancel();

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


      Future<bool> _onWillPop() async {
        if (typingList.contains(user.uid)) {
          typingList.remove(user.uid);
          updateTypelist(false);
        }
        return true;
      }

      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: ColorResource.white,
          key: scaffoldKey,
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
        ),
      );
    });
  }

  Widget MobileView() {
    return Container(
      alignment: Alignment.topLeft,
      color: ColorResource.off_white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Material(
            elevation: 10,
            child: Container(
              height: 60,
              color: ColorResource.toolbar_color,
              child: Row(
                mainAxisSize: MainAxisSize.max,
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
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(widget.userModel!.name, style: TextStyle(
                              color: ColorResource.white, fontSize: fontSize),),
                        ),

                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: Text((typingStatus.isNotEmpty)
                              ? typingStatus
                              : lastSeenStatus, style: TextStyle(
                              color: ColorResource.off_white, fontSize: 14),),
                        ),
                      ],

                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: (){
                          Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft, child:
                          FriendProfilePage(widget.userModel!.userId,widget.userModel!.name),));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.network(
                            widget.userModel!.image,
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Image.asset(
                                  'assets/images/no_img.png',
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.fitWidth);
                            },
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    itemCount: list.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      bool showBubble = false;
                      if(index==0)
                        showBubble = true;
                      else{
                        if(list[index].timestamp!=null) {
                          DateTime date = list[index - 1].timestamp!.toDate();
                          String pDate = DateFormat('dd/MMM/yyyy').format(date);

                          DateTime date2 = list[index].timestamp!.toDate();
                          String cDate = DateFormat('dd/MMM/yyyy').format(
                              date2);

                          if (pDate != cDate) {
                            showBubble = true;
                          }
                        }
                      }

                      if (list[index].sender_id == myDetail.userId) {
                        return new ChatItemSelf(list[index],this,controller,index,showBubble,widget.userModel!.name).ChatItem();
                      } else {
                        return new ChatItemOther(list[index],this,index,showBubble,widget.userModel!.name).ChatItem();
                      }
                    }
                ),
              )
          ),

          /*Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 24),
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (BuildContext context, int index) => ListTile(
                  title: Text("List Item ${index + 1}"),
                ),
              ),
            ),
          ),*/

          Container(
            color: ColorResource.white,
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomLeft,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: ()=>setState(() {
                        emojiShowing = !emojiShowing;
                      }),
                      child: Image.asset(ImageResource.icn_emoji,
                          height: 30,
                          width: 30,
                          fit:BoxFit.fill),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          onChanged: onMessageType,
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black,
                          controller: enterMsgController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 4,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          decoration: new InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey,
                                  width: 0.5),
                              borderRadius: new BorderRadius.circular(30),
                            ),
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey,
                                  width: 0.5),
                              borderRadius: new BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey,
                                  width: 0.5),
                              borderRadius: new BorderRadius.circular(30),
                            ),
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            counterText: "",
                            fillColor: Colors.white,
                            // contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            hintText: 'Write a message...',
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () async {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Select image"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: (){
                                        Navigator.of(context).pop();
                                        checkPermissionForCamera();
                                      },
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/icn_camera.png',
                                            fit: BoxFit.fitWidth,
                                            height: 30,
                                            width: 30,
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text("Camera", style: TextStyle(color: ColorResource.black_text , fontSize: 16),))
                                        ],
                                      ),
                                    ),

                                    InkWell(
                                      onTap: (){
                                        Navigator.of(context).pop();
                                        checkPermssionForGallery();
                                      },
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/icn_gallery.png',
                                            fit: BoxFit.fitWidth,
                                            height: 30,
                                            width: 30,
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text("Gallery", style: TextStyle(color: ColorResource.black_text , fontSize: 16),))
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                actions: <Widget>[
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.only(right: 10),
                                        child: Text("Cancel", style: TextStyle(color: ColorResource.google_red , fontSize: 16),)),
                                  )
                                ],
                              );
                            }
                        );

                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(ImageResource.file_icon,
                              height: 30,
                              width: 30,
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (enterMsgController.text
                            .trim()
                            .isNotEmpty) {
                          /*check().then((intenet) {
                            if (intenet != null && intenet) {
                              sendMessage(enterMsgController.text.trim(), "");
                            }else{
                              showSnackBar(
                                  scaffoldKey, "No internet connection", SnackBarType.ERROR);
                            }
                            // No-Internet Case
                          });*/

                          sendMessage(enterMsgController.text.trim(), "");

                        } else {
                          showSnackBar(
                              scaffoldKey, "Please enter message", SnackBarType.ERROR);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(ImageResource.icn_chat_send,
                              height: 30,
                              width: 30,
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ],
                ),
                Offstage(
                  offstage: !emojiShowing,
                  child: SizedBox(
                    height: 250,
                    child: EmojiPicker(
                        onEmojiSelected: (Category category, Emoji emoji) {
                          _onEmojiSelected(emoji);
                        },
                        onBackspacePressed: _onBackspacePressed,
                        config: const Config(
                            columns: 7,
                            emojiSizeMax: 32.0,
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            initCategory: Category.RECENT,
                            bgColor: Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            progressIndicatorColor: Colors.blue,
                            backspaceColor: Colors.blue,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            noRecentsText: 'No Recents',
                            noRecentsStyle:
                            TextStyle(fontSize: 20, color: Colors.black26),
                            categoryIcons: CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL)),
                  ),
                ),
              ],

            ),
          ),
        ],

      ),

    );
  }

  _onEmojiSelected(Emoji emoji) {
    enterMsgController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: enterMsgController.text.length));
  }

  _onBackspacePressed() {
    enterMsgController
      ..text = enterMsgController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: enterMsgController.text.length));
  }


  getChatId() async {

    QuerySnapshot<Map<String,dynamic>> querySnapshot =  await FirebaseFirestore.instance.collection("chat-messages")
        .where('group_members',arrayContains: {'id':user.uid,'phone':user.phoneNumber})
        .get();



    for(int i=0;i<querySnapshot.docs.length;i++){
      QueryDocumentSnapshot<Map<String,dynamic>> map = querySnapshot.docs[i];

      var arr = <dynamic>[];
      arr = map.get('group_members');
      if(!map.get('isGroup')){
        var idsss = <String>[];
        for(int i=0;i<arr.length;i++){
          var usermap = arr[i] as Map<String,dynamic>;
          idsss.add(usermap['id']);
        }
        print('fjkldsjklf'+idsss.toString());
        if(idsss.contains(widget.userModel!.userId)){
          widget.chatId= map.get('chatId');
          print('old_chat_id'+widget.chatId!);
          break;
        }

      }
    }

    if(widget.chatId==null){
      widget.chatId = FirebaseFirestore.instance.collection("chat-messages").doc().id;
      print('random_chat_id'+widget.chatId!);
    }else{
      print('_chat_id'+widget.chatId!);
    }
    getMyData();
    getTypeList();
    getChatMessages();
    addOnlineLisners();

  }


  Widget DesktopView() {
    return Container();
  }

  getChatMessages() {
    Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection("chat-messages").doc(widget.chatId!).collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots(includeMetadataChanges: false);

    _chatMsgListner = _usersStream.listen((event) async {


      var list2 = <ChatMessage>[];
      print('event.docs'+event.docs.length.toString());
      event.docs.forEach((result) async {
        print('getChatMessages');
        var data = result.data() as Map<String, dynamic>;
        //UserModel userModel = new UserModel(name:result.data()["name"],phone:result.data()["phone"],device_token:result.data()["device_token"],image:result.data()["image"]);
        ChatMessage model = ChatMessage.fromJson(data);
        model.message_id = result.id;
        model.chat_id = widget.chatId!;
        list2.add(model);

        if(model.isImage && model.image.isEmpty && model.sender_id==user.uid){
          print('MSG_id'+result.id);
          sendImageToFirebase(model, result.id);
        }
      });

      print('lgt'+list2.length.toString()+"__"+list.length.toString());
      bool isScroll = false;
      if(list2.length!=list.length)
      {
        isScroll = true;
      }
      setState(() {
        list = list2;
      });

      new Timer(const Duration(milliseconds: 100), () async {
        if(isScroll)
        {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 100),
          );
        }
      });



    });
  }

  downloadForSelfCache(ChatMessage model,position) async {

    setState(() {
      list[position].showProgress=true;
    });

    try{
      Img.Image? image  = await createDecodeImg(model);
      String imgType = model.self_thumbnail.split('.').last;
      File newFile = await createTempFile(model);
      if(imgType=='jpg' || imgType=='jpeg'){
        File filez =  await newFile.writeAsBytes(Img.encodeJpg(image!));


        await FirebaseFirestore.instance.collection("chat-messages").doc(
            model.chat_id).collection("messages").doc(model.message_id).update({'self_thumbnail': filez.path});

        setState(() {
          list[position].showProgress=false;
        });

      }else{
        File filez= await newFile.writeAsBytes(Img.encodePng(image!));
        await FirebaseFirestore.instance.collection("chat-messages").doc(
            model.chat_id).collection("messages").doc(model.message_id).update({'self_thumbnail': filez.path});

        setState(() {
          list[position].showProgress=false;
        });
      }

    }catch(e){
      setState(() {
        list[position].showProgress=false;
      });
      print("Errrororr"+e.toString());
      return null;
    }
  }

  /*updateChacheImage() async {
    for(int i=0;i<list.length;i++){
      ChatMessage model = list[i];
      if(model.isImage){
        if(model.sender_id==user.uid){
          File f = new File(model.self_thumbnail);
          bool isExits = await f.exists();
          if(!isExits){
            try{
              Img.Image? image  = await createDecodeImg(model);
              String imgType = model.self_thumbnail.split('.').last;
              File newFile = await createTempFile(model);
              if(imgType=='jpg' || imgType=='jpeg'){
                File filez =  await newFile.writeAsBytes(Img.encodeJpg(image!));
                await FirebaseFirestore.instance.collection("chat-messages").doc(
                    model.chat_id).collection("messages").doc(model.message_id).update({'self_thumbnail': filez.path});

              }else{
                File filez= await newFile.writeAsBytes(Img.encodePng(image!));
                await FirebaseFirestore.instance.collection("chat-messages").doc(
                    model.chat_id).collection("messages").doc(model.message_id).update({'self_thumbnail': filez.path});
              }

            }catch(e){
              print("Errrororr"+e.toString());
              return null;
            }
          }

        }else{
          *//*if(model.isShow){
            File f = new File(model.other_thumbnail);
            bool isExits = await f.exists();

            if(!isExits){
              try{
                Img.Image? image  = await createDecodeImg(model);
                String imgType = model.self_thumbnail.split('.').last;
                File newFile = await createTempFile(model);
                if(imgType=='jpg' || imgType=='jpeg'){
                  File filez =  await newFile.writeAsBytes(Img.encodeJpg(image!,quality: 10));
                  print("newFilePathGen"+filez.path);
                  await FirebaseFirestore.instance.collection("chat-messages").doc(
                      model.chat_id).collection("messages").doc(model.message_id).update({'other_thumbnail': filez.path});

                }else{
                  File filez= await newFile.writeAsBytes(Img.encodePng(image!));
                  await FirebaseFirestore.instance.collection("chat-messages").doc(
                      model.chat_id).collection("messages").doc(model.message_id).update({'other_thumbnail': filez.path});
                }

              }catch(e){
                print("Errrororr"+e.toString());
                return null;
              }
            }
          }*//*
        }

      }
    }
  }*/

  Future<Img.Image?> createDecodeImg(ChatMessage model) async {
    Uri uri;
    if(model.sender_id==user.uid){
      uri = Uri.parse(model.image);
    }else{
      uri = Uri.parse(model.image);
    }

    final http.Response downloadData = await http.get(uri);
    //print("newFilePath"+pathDownload);
    Img.Image? image = Img.decodeImage(downloadData.bodyBytes);

    return image;
  }

  Future<File> createTempFile(ChatMessage model) async {
    String fileName = model.self_thumbnail.split('/').last;;
    Directory? directory= await getTemporaryDirectory();

    String newPath  = directory.path.toString()+"/"+new DateTime.now().millisecondsSinceEpoch.toString()+'_'+fileName;
    File newFile = new File(newPath);
    return newFile.create();
  }
  sendImageToFirebase(ChatMessage model,String msg_id) async {
    var path = model.self_thumbnail;
    String name = model.self_thumbnail.split('/').last;
    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    Reference storageReference = FirebaseStorage
        .instance
        .ref()
        .child('user-chat-images').child(widget.chatId!).child(name);

    /*Reference storageReference2 = FirebaseStorage
        .instance
        .ref()
        .child('user-chat-images').child(widget.chatId!).child(
        'messages/thumbnail_img' + timestamp.toString() + name);*/

    //reference.putData(byteData.buffer.asUint8List());

    Map<String, String> map = {'msg_id': msg_id};
    SettableMetadata metadata = new SettableMetadata(customMetadata: map);

    File file = File(path);
    UploadTask uploadTask =
    storageReference.putFile(file, metadata);
    await uploadTask.whenComplete(() async {

      /*File imageFile = new File(model.self_thumbnail);
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      int rand = new DateTime.now().millisecondsSinceEpoch;
      Img.Image? image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImage = Img.copyResize(image!, width: 100); // choose the size here, it will maintain aspect ratio
      var compressedImage = new File('$path/img_$rand-$name')..writeAsBytesSync(Img.encodeJpg(smallerImage, quality: 10));
      UploadTask uploadTask2 =
      storageReference2.putFile(compressedImage);
      await uploadTask2.whenComplete(() async {
        updateMewssageAfterImageUpload(storageReference, storageReference2);
      });*/

      updateMewssageAfterImageUpload(storageReference);
    });

  }

  updateMewssageAfterImageUpload(Reference storageReference) async {
    String url = await storageReference.getDownloadURL();
    //String image_thnumb_url = await storageReference2.getDownloadURL();

    FullMetadata metadata = await storageReference.getMetadata();
    String? msgId = (metadata.customMetadata)!['msg_id'];
    await FirebaseFirestore.instance.collection("chat-messages").doc(
        widget.chatId!).collection("messages").doc(msgId).update({'image': url,'isShow':true});

    /*Map<String, dynamic> userMapOther =
    {
      'chatId': widget.chatId,
      'user_name': myDetail.name,
      'user_phone': user.phoneNumber,
      'user_id': user.uid,
      'sender_id': user.uid,
      'user_image': "self_image",
      'lastMessage': "",
      'isPhoto': true,
      'isTyping': typingList,
      'seen': false,
      'unreadMsgCount': unreadCount + 1,
      //'unreadMsgCount':0,
      'timestamp': FieldValue.serverTimestamp(),
      'device_token': "",
    };

    FirebaseFirestore.instance.collection("user-chats").doc(
        widget.userModel!.userId).collection("chatrooms").doc(user.uid).set(
        userMapOther);*/
  }


  Future<dynamic> postImage(Asset imageFile) async {


    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    /*StorageReference reference = _storage.ref().child(fileName);
    StorageUploadTask uploadTask =
    reference.putData(byteData.buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return await storageTaskSnapshot.ref.getDownloadURL();*/
  }


  Future<void> sendMessage(msg, String url) async {

    /*DateTime now = DateTime.now();
    String timestamp = DateFormat().format(now);
    String currentTime = DateFormat.jm().format(now);
    String currentDate = DateFormat('dd MMM yyyy').format(now);*/

    setState(() {
      enterMsgController.text = "";
      if (typingList.contains(user.uid)) {
        typingList.remove(user.uid);
        updateTypelist(false);
      }
    });

    var idss = <Map<String,dynamic>>[];
    idss.add({'id':user.uid,'phone':user.phoneNumber});
    idss.add({'id':widget.userModel!.userId,'phone':widget.userModel!.phone} );

    bool isPhoto = false;
    if (url.isNotEmpty)
      isPhoto = true;


    /*if(readMessageList[user.uid]!=null) {
      readMessageList.update(user.uid, (value) => list.length+1);
    }else{
      readMessageList.putIfAbsent(user.uid, () => list.length+1);
      //await FirebaseFirestore.instance.collection("chat-messages").doc(widget.chatId).update({'readMsgCount': readMessageList});
    }*/
    Map<String, dynamic> userMapSelf;
    if(list.isEmpty){
      userMapSelf =
      {
        'chatId': widget.chatId,
        'isGroup': false,
        'sender_id': user.uid,
        'group_members': idss,
        'lastMessage': msg,
        'isPhoto': isPhoto,
        'timestamp': FieldValue.serverTimestamp(),
        'isTyping':typingList,
        'messageLength': list.length+1,
      };
    }else{
      userMapSelf =
      {
        'chatId': widget.chatId,
        'isGroup': false,
        'sender_id': user.uid,
        'group_members': idss,
        'lastMessage': msg,
        'isPhoto': isPhoto,
        'timestamp': FieldValue.serverTimestamp(),
        'messageLength': list.length+1,
      };
    }
    Map<String, dynamic> msgMap =
    {
      'message': msg,
      'sender_id': user.uid,
      'image': "",
      'self_thumbnail': "",
      'other_downloaded_image': "",
      'isShow': true,
      'isImage': false,
      'timestamp': FieldValue.serverTimestamp()
    };



    FirebaseFirestore.instance.collection("chat-messages").doc(widget.chatId)
        .set(userMapSelf,SetOptions(merge: true));

    FirebaseFirestore.instance.collection("chat-messages").doc(widget.chatId)
    .collection('messages').add(msgMap);

  }

  Future<String> getUserDataFromSharedPref(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = await prefs.getString(key);
    return user!;
  }

  getMyData() async {
    String? user = await getUserDataFromSharedPref(
        SharedPrefConstants.USER_DATA);
    Map<String, dynamic> userMap = jsonDecode(user);
    myDetail = UserModel.fromJson(userMap);
  }


  addOnlineLisners() {
    Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection("users").doc(widget.userModel!.userId)
        .snapshots(includeMetadataChanges: false);
    _onlineListner = _usersStream.listen((result) {
      var data = result.data() as Map<String, dynamic>;
      if(data!=null) {
        setState(() {
          widget.userModel!.online = data['online'];
          if (widget.userModel!.online) {
            lastSeenStatus = "online";
          } else {
            Timestamp timestamp = data['lastSeenTime'] as Timestamp;
            DateTime tDate = timestamp.toDate();
            String formattedTime = DateFormat.jm().format(tDate);
            String formattedDate = DateFormat('dd MMM yyyy').format(tDate);

            DateTime now = timestamp.toDate();
            String cDate = DateFormat('dd MMM yyyy').format(now);
            if (cDate == formattedDate) {
              lastSeenStatus = 'last seen today at ' + formattedTime;
            } else {
              lastSeenStatus = 'last seen on ' + formattedDate;
            }
          }
        });
      }
    });
  }

  getTypeList() {
    if(widget.chatId!=null && widget.chatId!.isNotEmpty) {
      Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
          .collection("chat-messages")
          .doc(widget.chatId)
          .snapshots(includeMetadataChanges:false);
      _typelistListner = _usersStream.listen((result) async {
        var data = result.data() as Map<String, dynamic>;
        if (data != null) {
          typingList = data['isTyping'];

          //readMessageList = data['readMsgCount'];
          int messageLength = data['messageLength'];
          String sender_id = data['sender_id'];
          if(messageLength!=previousMsgLt){
            FirebaseFirestore.instance.collection("chat-messages").doc(widget.chatId).update({'readMsgCount.'+user.uid: messageLength});

            /*if(sender_id!=user.uid){
              if(readMessageList[user.uid]!=null) {
                readMessageList.update(user.uid, (value) => messageLength);
              }else{
                readMessageList.putIfAbsent(user.uid, () => messageLength);
              }
            }*/
          }

         // print('updatedUnread'+readMessageList.toString());
          setState(() {
            previousMsgLt= messageLength;
            if (typingList.isNotEmpty && (typingList.length>1 || !typingList.contains(user.uid))) {
              typingStatus = "typing...";
            } else {
              typingStatus = "";
            }
          });
        }
      });
    }
  }




  onMessageType(String s) {

    if (s.isNotEmpty) {
      if (!typingList.contains(user.uid)) {
        typingList.add(user.uid);
        updateTypelist(true);
      }
    } else {
      if (typingList.contains(user.uid)) {
        typingList.remove(user.uid);
        updateTypelist(false);
      }
    }
  }

  updateTypelist(bool isAdd) {
    print("typingList" + typingList.toString());
    if(isAdd){
      FirebaseFirestore.instance
          .collection("chat-messages")
          .doc(widget.chatId).update({'isTyping': FieldValue.arrayUnion([user.uid])});
    }else{
      FirebaseFirestore.instance
          .collection("chat-messages")
          .doc(widget.chatId).update({'isTyping': FieldValue.arrayRemove([user.uid])});
    }
  }




  Future getImage() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    List<Asset> images = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Select Photo",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print("errirImage" + error);
    }

    if (!mounted) return;

    check().then((intenet) {
      if (intenet != null && intenet) {
        new Timer(const Duration(milliseconds: 1000), () async {
          for (int i = 0; i < resultList.length; i++) {
            sendImageMsg(resultList[i],"");
            // await _saveImageToDisk(resultList[i]);
          }
        });
      }else{
        showSnackBar(
            scaffoldKey, "No internet connection", SnackBarType.ERROR);
      }
      // No-Internet Case
    });


  }

  /* Future<bool> checkPermission() async {
    if (await Permission.camera.request().isGranted
        && await Permission.storage.request().isGranted
       ) {
      return true;
      // Either the permission was already granted before or the user just granted it.
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.storage,
      ].request();

    }
    return false;
  }*/

  checkPermissionstorage() async {

    if ( await Permission.storage.request().isGranted ) {
      _createFolder();
    } else {
      Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
      if (statuses[Permission.storage]==PermissionStatus.granted ) {
        _createFolder();
      }else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      }else {
        _showPerissionSettingsDialog(
            "You have denied storage permission permanantly,Please go to settings and allow 'storage' permission");
      }
    }

  }

  Future<void> checkPermssionForGallery() async {
    if ( await Permission.storage.request().isGranted) {
      getImage();
    } else {
      Map<Permission, PermissionStatus> statuses = await [Permission.storage,].request();
      if (statuses[Permission.storage]==PermissionStatus.granted) {
        getImage();
      }else {
        _showPerissionSettingsDialog(
            "You have denied storage permission permanantly,Please go to settings and allow 'storage' permission");
      }
    }

  }


  sendImageMsg(Asset? asset,String imagePath) async {

    String path="";
    if(asset!=null) {
      path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
    }else{
      path = imagePath;
    }




    Map<String, dynamic> msgMap =
    {
      'message': '',
      'sender_id': user.uid,
      'image': '',
      'self_thumbnail': path,
      'other_downloaded_image': "",
      'isShow': false,
      'isImage': true,
      'timestamp': FieldValue.serverTimestamp()
    };

    var idss = <dynamic>[];
    idss.add({'id':user.uid,'phone':user.phoneNumber});
    idss.add({'id':widget.userModel!.userId,'phone':widget.userModel!.phone} );


    Map<String, dynamic> userMapSelf;
    if(list.isEmpty){
      userMapSelf =
      {
        'chatId': widget.chatId,
        'isGroup': false,
        'sender_id': user.uid,
        'group_members': idss,
        'lastMessage': '',
        'isPhoto': true,
        'timestamp': FieldValue.serverTimestamp(),
        'isTyping':typingList,
        'messageLength': list.length+1,
      };
    }else{
      userMapSelf =
      {
        'chatId': widget.chatId,
        'isGroup': false,
        'sender_id': user.uid,
        'group_members': idss,
        'lastMessage': '',
        'isPhoto': true,
        'timestamp': FieldValue.serverTimestamp(),
        'messageLength': list.length+1,
      };
    }


    FirebaseFirestore.instance.collection("chat-messages").doc(widget.chatId)
        .set(userMapSelf,SetOptions(merge: true));

    FirebaseFirestore.instance.collection("chat-messages").doc(widget.chatId)
        .collection('messages').add(msgMap);

  }

  checkPermissionForCamera() async {
    if (await Permission.camera.request().isGranted) {
      pickImageFromCamera();
    } else {
      Map<Permission, PermissionStatus> statuses = await [Permission.camera].request();
      if (statuses[Permission.contacts]==PermissionStatus.granted) {
        pickImageFromCamera();
      }else if(statuses[Permission.contacts]==PermissionStatus.permanentlyDenied){
        _showPerissionSettingsDialog("You have denied camera permission permanantly,Please go to settings and allow 'camera' permission");
      }
    }

  }

  pickImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      print("pickedFile.path"+pickedFile.path);
      check().then((intenet) {
        if (intenet != null && intenet) {
          sendImageMsg(null,pickedFile.path);
        }else{
          showSnackBar(
              scaffoldKey, "No internet connection", SnackBarType.ERROR);
        }
        // No-Internet Case
      });
      //File _image = File(pickedFile.path);

    } else {
      print('No image selected.');
    }
  }




  checkPermissionforDownload(ChatMessage model,position) async {
    if (await Permission.storage.request().isGranted) {
      downloadImage(model,position);
    } else {
      Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
      if (statuses[Permission.contacts]==PermissionStatus.granted) {
        downloadImage(model,position);
      }else if(statuses[Permission.contacts]==PermissionStatus.permanentlyDenied){
        _showPerissionSettingsDialog("You have denied storage permission permanantly,Please go to settings and allow 'storage' permission");
      }
    }
  }

  downloadImage(ChatMessage model,position) async
  {
    setState(() {
      list[position].showProgress=true;
    });
    try{
      Uri uri = Uri.parse(model.image);
      final http.Response downloadData = await http.get(uri);
      String pathDownload = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      Directory? directory=null;
      await new Directory(pathDownload).create().then((value) async {
        print("diectory created");
        directory = value;
        String newPath  = directory!.path.toString()+"/IMG_"+
            new DateTime.now().millisecondsSinceEpoch.toString()+'.'+model.self_thumbnail.split('.').last;
        File newFile = new File(newPath);
        newFile.create();
        String imgType = model.self_thumbnail.split('.').last;
        Img.Image? image = Img.decodeImage(downloadData.bodyBytes);
        if(imgType=='jpg' || imgType=='jpeg'){
          File filez =  await newFile.writeAsBytes(Img.encodeJpg(image!,quality: 80));
          await updateChatMessage(model,filez.path);
          setState(() {
            list[position].showProgress=false;
          });
        }else{
          File filez= await newFile.writeAsBytes(Img.encodePng(image!));
          print("newFilePathGen"+filez.path);
          await updateChatMessage(model,filez.path);
          setState(() {
            list[position].showProgress=false;
          });
          //sendImageMsg(filez);
        }

      });

    }catch(e){
      setState(() {
        list[position].showProgress=false;
      });
      print("Errrororr"+e.toString());
      return null;
    }
  }

  updateChatMessage(ChatMessage model,path) async {
    print("path_update"+path);
    await FirebaseFirestore.instance.collection("chat-messages").doc(
        model.chat_id).collection("messages").doc(model.message_id).update({'other_downloaded_image': path});
  }


  _showPerissionSettingsDialog(String msg){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Permission Denied"),
            content:  Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10),
                child: Text(msg, style: TextStyle(color: ColorResource.black_text , fontSize: 16),)),
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
  }


  navigateToLargeImage(String url,String name){
    Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft, child: LargeImagePage(url,name),));
  }


  _createFolder()async{

    /*final folderName="Bhej App";
    var dir = await getExternalStorageDirectory();
    final path=  Directory("storage/emulated/0/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create(recursive: true);
      return path.path;
    }*/

    final folderName="Bhej";
    final imagesfolderName="Images";
    final sentfolderName="Sent";
    final receivedfolderName="Received";
    final statusfolderName="Status";
    final myImagesfolderName="MyImages";
    final otherImagesfolderName="OtherImages";
    Directory appDocDir = (await getExternalStorageDirectory())!;
    String appDocPath = appDocDir.path;

    final Directory _appDocDirFolder = Directory('${appDocPath}/$folderName/$imagesfolderName/$sentfolderName/$receivedfolderName/$statusfolderName/$myImagesfolderName/$otherImagesfolderName');
   // final Directory _appimagesDirFolder = Directory('${appDocPath}/$folderName/$imagesfolderName/');

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await _appDocDirFolder.exists())) {
      print(_appDocDirFolder.path);
      return _appDocDirFolder.path;

    } else {
      _appDocDirFolder.create(recursive: true);
   //   _appimagesDirFolder.create(recursive: true);
      print(_appDocDirFolder.path);
      return _appDocDirFolder.path;
    }
  }


}












