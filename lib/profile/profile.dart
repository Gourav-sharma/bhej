
import 'dart:async';
import 'dart:io';

import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/environment/environment.dart';
import 'package:bhej/shared/utils/helper.dart';
import 'package:bhej/ui/largeimage/largeimagepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
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
  String userImage = "";
  String userName = "";
  String userMobile = "";
  String userbio = "";
  final picker = ImagePicker();
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  late StreamSubscription<DocumentSnapshot> _userListner;
  late User user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    getUserInfo();
    super.initState();
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



      return Scaffold(
        backgroundColor: ColorResource.white,
        key: scaffoldKey,
        body: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: ColorResource.toolbar_color,
                title: Text("Profile",
                  style: TextStyle(
                      color: ColorResource.white
                  ),),
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.logout), onPressed: () {
                      Environment.showAlertDialog(context, "Are you sure you want to logout?");
                    }),
                  ]
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
            )
          /**/
        ),
      );
    });
  }

  Widget MobileView() {
    return SingleChildScrollView(
      child: Container(
        width: descriptionSize,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                      width: 150,
                      height: 150,
                      child: InkWell(
                        onTap: (){
                          if(userImage!=null && userImage.isNotEmpty) {
                            Navigator.push(context, PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: LargeImagePage(userImage,userName),));
                          }
                        },
                        child: ClipOval(
                            child: Image.network(
                              userImage,
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
                      onTap: () {
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
                      },// handle your onTap here
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
                margin: EdgeInsets.only(top:50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width:20,
                        margin: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.account_circle,
                          size: 25,
                          color: ColorResource.toolbar_color,
                        )
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name"
                              ,style: TextStyle(color: ColorResource.gray2,fontSize: 14,fontWeight: FontWeight.normal),
                            ),

                            Container(
                              width: displayWidth(context) * 0.80,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                userName,
                                style: TextStyle(color: ColorResource.black_text,fontSize: 14,fontWeight: FontWeight.normal),
                              ),
                            ),

                            Container(
                              width: displayWidth(context) * 0.80,
                              height: 0.5,
                              margin: EdgeInsets.only(top: 10),
                              color: ColorResource.gray,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        updateName();
                      },
                      child: Container(
                          width:20,
                          margin: EdgeInsets.only(top: 2,right: 10),
                          child: Icon(
                            Icons.edit,
                            size: 25,
                            color: ColorResource.toolbar_color,
                          )
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: descriptionSize,
                margin: EdgeInsets.only(top:20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width:20,
                        margin: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.info_outline,
                          size: 25,
                          color: ColorResource.toolbar_color,
                        )
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "About"
                              ,style: TextStyle(color: ColorResource.gray2,fontSize: 14,fontWeight: FontWeight.normal),
                            ),
                            Container(
                              width: displayWidth(context) * 0.80,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                userbio,
                                style: TextStyle(color: ColorResource.black_text,fontSize: 14,fontWeight: FontWeight.normal),
                              ),

                            ),
                            Container(
                              width: displayWidth(context) * 0.80,
                              height: 0.5,
                              margin: EdgeInsets.only(top: 10),
                              color: ColorResource.gray,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        updateBio();
                      },
                      child: Container(
                          width:20,
                          margin: EdgeInsets.only(top: 2,right: 10),
                          child: Icon(
                            Icons.edit,
                            size: 25,
                            color: ColorResource.toolbar_color,
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: descriptionSize,
                margin: EdgeInsets.only(top:20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width:20,
                        margin: EdgeInsets.only(top: 2),
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
                            ,style: TextStyle(color: ColorResource.gray2,fontSize: 14,fontWeight: FontWeight.normal),
                          ),
                          Container(
                            width: displayWidth(context) * 0.80,
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              userMobile,
                              style: TextStyle(color: ColorResource.black_text,fontSize: 14,fontWeight: FontWeight.normal),
                            ),

                          ),
                          Container(
                            width: displayWidth(context) * 0.80,
                            height: 0.5,
                            margin: EdgeInsets.only(top: 10),
                            color: ColorResource.gray,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )

            ],
          ),
        ),

      ),
    );

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
      _cropImage(pickedFile.path);
      //File _image = File(pickedFile.path);

    } else {
      print('No image selected.');
    }
  }

  Future<Null> _cropImage(String path) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: Platform.isAndroid
        ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.original,
        ]
        : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: ColorResource.toolbar_color,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      sendImageToFirebase(croppedFile.path);
    }
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

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print("pickedFile.path"+pickedFile.path);
      _cropImage(pickedFile.path);

      //File _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }


  sendImageToFirebase(String path) async {
    setState(() {
      showProgressBar = true;
    });
    User user = FirebaseAuth.instance.currentUser!;
    String name = path.split('/').last;
    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    Reference storageReference = FirebaseStorage
        .instance
        .ref()
        .child('profle-images').child(user.uid+'.png');

    File file = File(path);
    UploadTask uploadTask =
    storageReference.putFile(file);
    await uploadTask.whenComplete(() async {
      String url = await storageReference.getDownloadURL();
      await FirebaseFirestore.instance.collection("users").doc(
          user.uid).update({'image': url});

      setState(() {
        showProgressBar = false;
        userImage = url;
      });
    });

  }

  getUserInfo() async {
    Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots(includeMetadataChanges:false);
    _userListner = _usersStream.listen((result) async {
      var data = result.data() as Map<String, dynamic>;
      if(data!=null){
        String image = data['image'];
        String name = data['name'];
        String phone = data['phone'];
        String bio = data['bio'];

        setState(() {
          userImage = image;
          userName = name;
          userMobile = phone;
          userbio = bio;
        });
      }
    });
  }

  updateName(){
    setState(() {
      _nameController.text = userName;
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Container(
                alignment: Alignment.center,
                child: AlertDialog(
                  title: Text("Enter Name"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _nameController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        if(_nameController.text.trim().isNotEmpty){
                          check().then((intenet) async {
                            if (intenet != null && intenet) {
                              Navigator.pop(context);
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(user.uid).update({'name': _nameController.text.trim()});
                            }else{
                              showSnackBar(
                                  scaffoldKey, "No internet connection", SnackBarType.ERROR);
                            }
                            // No-Internet Case
                          });
                        }else{
                          showSnackBar(
                              scaffoldKey, "Name can not be empty", SnackBarType.ERROR);
                        }


                      },
                    )
                  ],
                ),
              );
            },

          );
        }
    );
  }


  updateBio(){
    setState(() {
      _aboutController.text = userbio;
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Container(
                alignment: Alignment.center,
                child: AlertDialog(
                  title: Text("Enter About Yourself"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _aboutController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        if(_aboutController.text.trim().isNotEmpty){
                          check().then((intenet) async {
                            if (intenet != null && intenet) {
                              Navigator.pop(context);
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(user.uid).update({'bio': _aboutController.text.trim()});
                            }else{
                              showSnackBar(
                                  scaffoldKey, "No internet connection", SnackBarType.ERROR);
                            }
                            // No-Internet Case
                          });
                        }else{
                          showSnackBar(
                              scaffoldKey, "Name can not be empty", SnackBarType.ERROR);
                        }


                      },
                    )
                  ],
                ),
              );
            },

          );
        }
    );
  }

  Widget DesktopView() {

    return Container();

  }
}