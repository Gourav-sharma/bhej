

import 'dart:convert';

import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/constants/database.dart';
import 'package:bhej/environment/environment.dart';
import 'package:bhej/environment/session_manager.dart';
import 'package:bhej/shared/utils/helper.dart';
import 'package:bhej/ui/Inbox/inboxpage.dart';
import 'package:bhej/ui/Login/UserModel.dart';
import 'package:bhej/ui/homepage/homepage.dart';
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
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_localizations.dart';


import '../UserContacts.dart';

class Login extends StatefulWidget{

  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showProgressBar = false;
  bool showProgressBar2 = false;
  bool autoVerification = false;
  final formKey = new GlobalKey<FormState>();
  double? descriptionSize;
  double? bodyWidthSize;
  double? bodyheightSize;
  double? fontSize;
  double? topShapeSize;

  TextEditingController enterNumberController = new TextEditingController();
  TextEditingController enterNameController = new TextEditingController();
  final _codeController = TextEditingController();

  String dialCode = "+91";
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
        key: scaffoldKey,

        body: SafeArea(
          child: LoadingOverlay(
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
        ),
      );
    });
  }

  Widget  MobileView() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Bhej", style: TextStyle(color: ColorResource.toolbar_color , fontSize: 30,fontWeight: FontWeight.bold),),
                ),
                Container(
                  child: Text("Instant messaging app", style: TextStyle(color: ColorResource.toolbar_color , fontSize: fontSize),),
                ),
              ],
            ),
          )),
          Expanded(
              child: Scrollbar(
                  child:ListView(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child:  FormUi(),
                      ),
                    ],
                  )
              ))
        ],
      ),
    );
  }

  Widget  DesktopView() {

    return Container();

  }

  Widget FormUi(){

    return  Container(
      width: descriptionSize,
      color: ColorResource.white,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text("Phone Number",style: TextStyle(color: Colors.black , fontSize: 16 , fontStyle: FontStyle.normal),
                textAlign: TextAlign.center,
              ),
            ),*/
          /*Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: TextFormField(
              //onChanged: onChangedUserName,
              textAlign: TextAlign.start,
              maxLength: 10,
              cursorColor: Colors.black,
              controller: enterNumberController,
              //focusNode: emailNode,

              //enableSuggestions: true,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 16 , color: Colors.black),
              decoration: new InputDecoration(
                counterText: "",
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                hintText: 'Enter mobile number',
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.green),
                  borderRadius: new BorderRadius.circular(1),
                ),
              ),
            ),
          ),*/

          Container(
            width: descriptionSize,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            decoration: BoxDecoration(
                border: Border.all()
            ),
            child: Row(
              children: [
                CountryCodePicker(
                  onChanged: (e) {
                    dialCode = e.dialCode!;
                    print("dialCode"+dialCode);
                  },
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'IN',
                  //favorite: ['+91','IN'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  showFlag: true,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                  countryList: createCountryList(),

                ),
                Expanded(
                  child: TextFormField(
                    //onChanged: onChangedUserName,
                    textAlign: TextAlign.start,
                    maxLength: 10,
                    cursorColor: Colors.black,
                    controller: enterNumberController,
                    //focusNode: emailNode,

                    //enableSuggestions: true,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 16 , color: Colors.black),
                    decoration: new InputDecoration(
                      counterText: "",
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      hintText: 'Enter mobile number',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),



          /*Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: TextFormField(
              //onChanged: onChangedUserName,
              textAlign: TextAlign.start,
              maxLength: 100,
              cursorColor: Colors.black,
              controller: enterNameController,
              //focusNode: emailNode,

              //enableSuggestions: true,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16 , color: Colors.black),
              decoration: new InputDecoration(
                counterText: "",
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                hintText: 'Enter your name',
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.green),
                  borderRadius: new BorderRadius.circular(1),
                ),
              ),
            ),
          ),*/
          Container(
              height: 50,
              width: widthScrren,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: RaisedButton(
                textColor: Colors.black,
                color: ColorResource.toolbar_color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                  ),
                ),
                onPressed: () {
                  onValidCheck();

                  //validator();
                },
              )),
        ],
      ),
    );
  }

  void onValidCheck() {

    print("dialCode"+dialCode);
    final phone = enterNumberController.text.trim();
    final name = enterNameController.text.trim();

    if (phone.length==10) {

      check().then((intenet) {
        if (intenet != null && intenet) {
          loginUser(dialCode+phone, name,context);
        }else{
          showSnackBar(
              scaffoldKey, "No internet connection", SnackBarType.ERROR);
        }
        // No-Internet Case
      });

    }else {
      Environment.showValidationAlertDialog(context, "Please enter 10 digit mobile number");
    }
  }


  void loginUser(String phone, String name , BuildContext context) async {

    setState(() {
      showProgressBar = true;
    });

    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        setState(() {
          autoVerification = true;
        });
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        await _auth.signInWithCredential(credential).then((user) async {
          registerUserToFirestore(_auth,user.user,name);

        }).catchError((ex){
          setState(() {
            showProgressBar = false;
          });

          _codeController.clear();
          print("Error"+ex.toString());
          //showSnackBar(scaffoldKey, ex.toString(), SnackBarType.ERROR);
        });;

      },

      verificationFailed: (FirebaseAuthException exception){
        setState(() {
          showProgressBar = false;
        });
        print(exception.message);
      },


      codeSent: (verificationId, forceResendingToken) async {
        setState(() {
          showProgressBar = false;
        });
        if(!autoVerification) {
          showOTPdialog(verificationId, _auth,name);
        }
      },

      codeAutoRetrievalTimeout: (verificationId) {

        setState(() {
          showProgressBar = false;
        });
        showSnackBar(
            scaffoldKey, "TimeOut", SnackBarType.ERROR);

      },);
  }

  showOTPdialog(String verificationId,FirebaseAuth _auth,String name){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return LoadingOverlay(
                isLoading: showProgressBar2,
                child: Container(
                  alignment: Alignment.center,
                  child: AlertDialog(
                    title: Text("Enter Your Otp"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Confirm"),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {
                          check().then((intenet) async {
                            if (intenet != null && intenet) {
                              startLoader(setState);

                              print("verificationId_" + verificationId);
                              final code = _codeController.text.trim();
                              PhoneAuthCredential credential = PhoneAuthProvider
                                  .credential(
                                  verificationId: verificationId, smsCode: code);
                              await _auth.signInWithCredential(credential).then((
                                  user) async {

                                registerUserToFirestore(_auth,user.user,name);

                              }).catchError((ex) {
                                cancelLoader(setState);
                                Navigator.of(context).pop();
                                _codeController.clear();
                                print("Error" + ex.toString());
                                showSnackBar(
                                    scaffoldKey, ex.toString(), SnackBarType.ERROR);
                              });
                            }else{
                              showSnackBar(
                                  scaffoldKey, "No internet connection", SnackBarType.ERROR);
                            }
                            // No-Internet Case
                          });

                        },
                      )
                    ],
                  ),
                ),
              );
            },

          );
        }
    );
  }

  startLoader(setState){
    setState(() {
      showProgressBar2 = true;
    });
  }

  cancelLoader(setState){
    setState(() {
      showProgressBar2 = false;
    });
  }

  Future<void> registerUserToFirestore(FirebaseAuth _auth, User? user ,String name) async {
    if(user != null){
      // showSnackBar(scaffoldKey, "Auto verified successfully", SnackBarType.ERROR);

      try {
        QuerySnapshot<Map<String,dynamic>> querySnapshot =  await FirebaseFirestore.instance.collection("users")
            .where('phone',isEqualTo: user.phoneNumber)
            .get();
        print('querySnapshot'+querySnapshot.docs.length.toString());
        if(querySnapshot!=null && querySnapshot.docs.length>0 && querySnapshot.docs[0].get('phone')==user.phoneNumber){

          UserModel userModel = new UserModel(
            name: querySnapshot.docs[0].get('name'),
            phone: user.phoneNumber ,
            bio: querySnapshot.docs[0].get('bio'),
            device_token: querySnapshot.docs[0].get('device_token'),
            image: querySnapshot.docs[0].get('image'),
            userId: user.uid,
            online: true,
            lastSeenTime: Timestamp.now(),
          );

          String userJson = jsonEncode(userModel);

          final prefs = await SharedPreferences.getInstance();
          var success = await prefs.setString(SharedPrefConstants.USER_DATA, userJson);

          setState(() {
            showProgressBar = false;
            showProgressBar2 = false;
          });

          Navigator.pop(context);
          Navigator.pushReplacement(context,PageTransition(type: PageTransitionType.rightToLeft, child: InboxPage(),));
        }else{
          UserModel userModel = new UserModel(
            name: '' ,
            phone: user.phoneNumber ,
            bio: 'Available',
            device_token: "",
            image: "",
            userId: user.uid,
            online: true,
            lastSeenTime: Timestamp.now(),
          );

          String userJson = jsonEncode(userModel);
          await FirebaseFirestore.instance.collection('users')
              .doc(user.uid).set(userModel.toMap());

          final prefs = await SharedPreferences.getInstance();
          var success = await prefs.setString(SharedPrefConstants.USER_DATA, userJson);

          setState(() {
            showProgressBar = false;
            showProgressBar2 = false;
          });

          Navigator.pop(context);
          Navigator.pushReplacement(context,PageTransition(type: PageTransitionType.rightToLeft, child: InboxPage(),));
        }





        //Navigator.pushNamed(context, '/');
      } catch (e) {
        setState(() {
          showProgressBar = false;
          showProgressBar2 = false;
        });
        print('Error Happened!!!: $e');
      }
    }else{
      setState(() {
        showProgressBar = false;
        showProgressBar2 = false;
      });
      Navigator.of(context).pop();
      print("Error");
    }
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
      _fetchContacts();
      // Either the permission was already granted before or the user just granted it.
    } else {
      Map<Permission, PermissionStatus> statuses = await [Permission.contacts,].request();
      if(PermissionStatus==Permission.contacts.request().isGranted){
        _fetchContacts();
      }else{
        Navigator.pop(context);
        Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft, child: InboxPage(),));
      }
    }
    return false;
  }

  _fetchContacts() async {
    /**/
    setState(() {
      showProgressBar = true;
    });
    List<UserContact> contactList = <UserContact>[];
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
      }

    }

    final String encodedData = UserContact.encode(contactList);

    final prefs = await SharedPreferences.getInstance();
    var success = await prefs.setString(SessionManager.USER_CONTACTS, encodedData);

    setState(() {
      showProgressBar = false;
    });

    if(success){
      Navigator.pop(context);
      Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft, child: InboxPage(),));


      /*Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new InboxPage()));*/
    }
  }



  List<Map<String,String>> createCountryList(){
    List<Map<String, String>> codes = [
      {
        "name": "Afghanistan",
        "code": "AF",
        "dial_code": "+93",
      },
      {
        "name": "??land",
        "code": "AX",
        "dial_code": "+358",
      },
      {
        "name": "Shqip??ria",
        "code": "AL",
        "dial_code": "+355",
      },
      {
        "name": "??????????????",
        "code": "DZ",
        "dial_code": "+213",
      },
      {
        "name": "American Samoa",
        "code": "AS",
        "dial_code": "+1684",
      },
      {
        "name": "Andorra",
        "code": "AD",
        "dial_code": "+376",
      },
      {
        "name": "Angola",
        "code": "AO",
        "dial_code": "+244",
      },
      {
        "name": "Anguilla",
        "code": "AI",
        "dial_code": "+1264",
      },
      {
        "name": "Antarctica",
        "code": "AQ",
        "dial_code": "+672",
      },
      {
        "name": "Antigua and Barbuda",
        "code": "AG",
        "dial_code": "+1268",
      },
      {
        "name": "Argentina",
        "code": "AR",
        "dial_code": "+54",
      },
      {
        "name": "????????????????",
        "code": "AM",
        "dial_code": "+374",
      },
      {
        "name": "Aruba",
        "code": "AW",
        "dial_code": "+297",
      },
      {
        "name": "Australia",
        "code": "AU",
        "dial_code": "+61",
      },
      {
        "name": "??sterreich",
        "code": "AT",
        "dial_code": "+43",
      },
      {
        "name": "Az??rbaycan",
        "code": "AZ",
        "dial_code": "+994",
      },
      {
        "name": "Bahamas",
        "code": "BS",
        "dial_code": "+1242",
      },
      {
        "name": "?????????????????",
        "code": "BH",
        "dial_code": "+973",
      },
      {
        "name": "Bangladesh",
        "code": "BD",
        "dial_code": "+880",
      },
      {
        "name": "Barbados",
        "code": "BB",
        "dial_code": "+1246",
      },
      {
        "name": "??????????????????",
        "code": "BY",
        "dial_code": "+375",
      },
      {
        "name": "Belgi??",
        "code": "BE",
        "dial_code": "+32",
      },
      {
        "name": "Belize",
        "code": "BZ",
        "dial_code": "+501",
      },
      {
        "name": "B??nin",
        "code": "BJ",
        "dial_code": "+229",
      },
      {
        "name": "Bermuda",
        "code": "BM",
        "dial_code": "+1441",
      },
      {
        "name": "??brug-yul",
        "code": "BT",
        "dial_code": "+975",
      },
      {
        "name": "Bolivia",
        "code": "BO",
        "dial_code": "+591",
      },
      {
        "name": "Bosna i Hercegovina",
        "code": "BA",
        "dial_code": "+387",
      },
      {
        "name": "Botswana",
        "code": "BW",
        "dial_code": "+267",
      },
      {
        "name": "Bouvet??ya",
        "code": "BV",
        "dial_code": "+47",
      },
      {
        "name": "Brasil",
        "code": "BR",
        "dial_code": "+55",
      },
      {
        "name": "British Indian Ocean Territory",
        "code": "IO",
        "dial_code": "+246",
      },
      {
        "name": "Negara Brunei Darussalam",
        "code": "BN",
        "dial_code": "+673",
      },
      {
        "name": "????????????????",
        "code": "BG",
        "dial_code": "+359",
      },
      {
        "name": "Burkina Faso",
        "code": "BF",
        "dial_code": "+226",
      },
      {
        "name": "Burundi",
        "code": "BI",
        "dial_code": "+257",
      },
      {
        "name": "Cambodia",
        "code": "KH",
        "dial_code": "+855",
      },
      {
        "name": "Cameroon",
        "code": "CM",
        "dial_code": "+237",
      },
      {
        "name": "Canada",
        "code": "CA",
        "dial_code": "+1",
      },
      {
        "name": "Cabo Verde",
        "code": "CV",
        "dial_code": "+238",
      },
      {
        "name": "Cayman Islands",
        "code": "KY",
        "dial_code": "+1345",
      },
      {
        "name": "K??d??r??s??se t?? B??afr??ka",
        "code": "CF",
        "dial_code": "+236",
      },
      {
        "name": "Tchad",
        "code": "TD",
        "dial_code": "+235",
      },
      {
        "name": "Chile",
        "code": "CL",
        "dial_code": "+56",
      },
      {
        "name": "??????",
        "code": "CN",
        "dial_code": "+86",
      },
      {
        "name": "Christmas Island",
        "code": "CX",
        "dial_code": "+61",
      },
      {
        "name": "Cocos (Keeling) Islands",
        "code": "CC",
        "dial_code": "+61",
      },
      {
        "name": "Colombia",
        "code": "CO",
        "dial_code": "+57",
      },
      {
        "name": "Komori",
        "code": "KM",
        "dial_code": "+269",
      },
      {
        "name": "R??publique du Congo",
        "code": "CG",
        "dial_code": "+242",
      },
      {
        "name": "R??publique d??mocratique du Congo",
        "code": "CD",
        "dial_code": "+243",
      },
      {
        "name": "Cook Islands",
        "code": "CK",
        "dial_code": "+682",
      },
      {
        "name": "Costa Rica",
        "code": "CR",
        "dial_code": "+506",
      },
      {
        "name": "C??te d'Ivoire",
        "code": "CI",
        "dial_code": "+225",
      },
      {
        "name": "Hrvatska",
        "code": "HR",
        "dial_code": "+385",
      },
      {
        "name": "Cuba",
        "code": "CU",
        "dial_code": "+53",
      },
      {
        "name": "????????????",
        "code": "CY",
        "dial_code": "+357",
      },
      {
        "name": "??esk?? republika",
        "code": "CZ",
        "dial_code": "+420",
      },
      {
        "name": "Danmark",
        "code": "DK",
        "dial_code": "+45",
      },
      {
        "name": "Djibouti",
        "code": "DJ",
        "dial_code": "+253",
      },
      {
        "name": "Dominica",
        "code": "DM",
        "dial_code": "+1767",
      },
      {
        "name": "Rep??blica Dominicana",
        "code": "DO",
        "dial_code": "+1",
      },
      {
        "name": "Ecuador",
        "code": "EC",
        "dial_code": "+593",
      },
      {
        "name": "?????????",
        "code": "EG",
        "dial_code": "+20",
      },
      {
        "name": "El Salvador",
        "code": "SV",
        "dial_code": "+503",
      },
      {
        "name": "Guinea Ecuatorial",
        "code": "GQ",
        "dial_code": "+240",
      },
      {
        "name": "????????????",
        "code": "ER",
        "dial_code": "+291",
      },
      {
        "name": "Eesti",
        "code": "EE",
        "dial_code": "+372",
      },
      {
        "name": "???????????????",
        "code": "ET",
        "dial_code": "+251",
      },
      {
        "name": "Falkland Islands",
        "code": "FK",
        "dial_code": "+500",
      },
      {
        "name": "F??royar",
        "code": "FO",
        "dial_code": "+298",
      },
      {
        "name": "Fiji",
        "code": "FJ",
        "dial_code": "+679",
      },
      {
        "name": "Suomi",
        "code": "FI",
        "dial_code": "+358",
      },
      {
        "name": "France",
        "code": "FR",
        "dial_code": "+33",
      },
      {
        "name": "Guyane fran??aise",
        "code": "GF",
        "dial_code": "+594",
      },
      {
        "name": "Polyn??sie fran??aise",
        "code": "PF",
        "dial_code": "+689",
      },
      {
        "name": "Territoire des Terres australes et antarctiques fr",
        "code": "TF",
        "dial_code": "+262",
      },
      {
        "name": "Gabon",
        "code": "GA",
        "dial_code": "+241",
      },
      {
        "name": "Gambia",
        "code": "GM",
        "dial_code": "+220",
      },
      {
        "name": "??????????????????????????????",
        "code": "GE",
        "dial_code": "+995",
      },
      {
        "name": "Deutschland",
        "code": "DE",
        "dial_code": "+49",
      },
      {
        "name": "Ghana",
        "code": "GH",
        "dial_code": "+233",
      },
      {
        "name": "Gibraltar",
        "code": "GI",
        "dial_code": "+350",
      },
      {
        "name": "????????????",
        "code": "GR",
        "dial_code": "+30",
      },
      {
        "name": "Kalaallit Nunaat",
        "code": "GL",
        "dial_code": "+299",
      },
      {
        "name": "Grenada",
        "code": "GD",
        "dial_code": "+1473",
      },
      {
        "name": "Guadeloupe",
        "code": "GP",
        "dial_code": "+590",
      },
      {
        "name": "Guam",
        "code": "GU",
        "dial_code": "+1671",
      },
      {
        "name": "Guatemala",
        "code": "GT",
        "dial_code": "+502",
      },
      {
        "name": "Guernsey",
        "code": "GG",
        "dial_code": "+44",
      },
      {
        "name": "Guin??e",
        "code": "GN",
        "dial_code": "+224",
      },
      {
        "name": "Guin??-Bissau",
        "code": "GW",
        "dial_code": "+245",
      },
      {
        "name": "Guyana",
        "code": "GY",
        "dial_code": "+592",
      },
      {
        "name": "Ha??ti",
        "code": "HT",
        "dial_code": "+509",
      },
      {
        "name": "Heard Island and McDonald Islands",
        "code": "HM",
        "dial_code": "+0",
      },
      {
        "name": "Vaticano",
        "code": "VA",
        "dial_code": "+379",
      },
      {
        "name": "Honduras",
        "code": "HN",
        "dial_code": "+504",
      },
      {
        "name": "??????",
        "code": "HK",
        "dial_code": "+852",
      },
      {
        "name": "Magyarorsz??g",
        "code": "HU",
        "dial_code": "+36",
      },
      {
        "name": "??sland",
        "code": "IS",
        "dial_code": "+354",
      },
      {
        "name": "India",
        "code": "IN",
        "dial_code": "+91",
      },
      {
        "name": "Indonesia",
        "code": "ID",
        "dial_code": "+62",
      },
      {
        "name": "??????????",
        "code": "IR",
        "dial_code": "+98",
      },
      {
        "name": "????????????",
        "code": "IQ",
        "dial_code": "+964",
      },
      {
        "name": "??ire",
        "code": "IE",
        "dial_code": "+353",
      },
      {
        "name": "Isle of Man",
        "code": "IM",
        "dial_code": "+44",
      },
      {
        "name": "??????????",
        "code": "IL",
        "dial_code": "+972",
      },
      {
        "name": "Italia",
        "code": "IT",
        "dial_code": "+39",
      },
      {
        "name": "Jamaica",
        "code": "JM",
        "dial_code": "+1876",
      },
      {
        "name": "??????",
        "code": "JP",
        "dial_code": "+81",
      },
      {
        "name": "Jersey",
        "code": "JE",
        "dial_code": "+44",
      },
      {
        "name": "????????????",
        "code": "JO",
        "dial_code": "+962",
      },
      {
        "name": "??????????????????",
        "code": "KZ",
        "dial_code": "+7",
      },
      {
        "name": "Kenya",
        "code": "KE",
        "dial_code": "+254",
      },
      {
        "name": "Kiribati",
        "code": "KI",
        "dial_code": "+686",
      },
      {
        "name": "??????",
        "code": "KP",
        "dial_code": "+850",
      },
      {
        "name": "????????????",
        "code": "KR",
        "dial_code": "+82",
      },
      {
        "name": "Republika e Kosov??s",
        "code": "XK",
        "dial_code": "+383",
      },
      {
        "name": "????????????",
        "code": "KW",
        "dial_code": "+965",
      },
      {
        "name": "????????????????????",
        "code": "KG",
        "dial_code": "+996",
      },
      {
        "name": "??????????????????",
        "code": "LA",
        "dial_code": "+856",
      },
      {
        "name": "Latvija",
        "code": "LV",
        "dial_code": "+371",
      },
      {
        "name": "??????????",
        "code": "LB",
        "dial_code": "+961",
      },
      {
        "name": "Lesotho",
        "code": "LS",
        "dial_code": "+266",
      },
      {
        "name": "Liberia",
        "code": "LR",
        "dial_code": "+231",
      },
      {
        "name": "?????????????",
        "code": "LY",
        "dial_code": "+218",
      },
      {
        "name": "Liechtenstein",
        "code": "LI",
        "dial_code": "+423",
      },
      {
        "name": "Lietuva",
        "code": "LT",
        "dial_code": "+370",
      },
      {
        "name": "Luxembourg",
        "code": "LU",
        "dial_code": "+352",
      },
      {
        "name": "??????",
        "code": "MO",
        "dial_code": "+853",
      },
      {
        "name": "????????????????????",
        "code": "MK",
        "dial_code": "+389",
      },
      {
        "name": "Madagasikara",
        "code": "MG",
        "dial_code": "+261",
      },
      {
        "name": "Malawi",
        "code": "MW",
        "dial_code": "+265",
      },
      {
        "name": "Malaysia",
        "code": "MY",
        "dial_code": "+60",
      },
      {
        "name": "Maldives",
        "code": "MV",
        "dial_code": "+960",
      },
      {
        "name": "Mali",
        "code": "ML",
        "dial_code": "+223",
      },
      {
        "name": "Malta",
        "code": "MT",
        "dial_code": "+356",
      },
      {
        "name": "M??aje??",
        "code": "MH",
        "dial_code": "+692",
      },
      {
        "name": "Martinique",
        "code": "MQ",
        "dial_code": "+596",
      },
      {
        "name": "??????????????????",
        "code": "MR",
        "dial_code": "+222",
      },
      {
        "name": "Maurice",
        "code": "MU",
        "dial_code": "+230",
      },
      {
        "name": "Mayotte",
        "code": "YT",
        "dial_code": "+262",
      },
      {
        "name": "M??xico",
        "code": "MX",
        "dial_code": "+52",
      },
      {
        "name": "Micronesia",
        "code": "FM",
        "dial_code": "+691",
      },
      {
        "name": "Moldova",
        "code": "MD",
        "dial_code": "+373",
      },
      {
        "name": "Monaco",
        "code": "MC",
        "dial_code": "+377",
      },
      {
        "name": "???????????? ??????",
        "code": "MN",
        "dial_code": "+976",
      },
      {
        "name": "???????? ????????",
        "code": "ME",
        "dial_code": "+382",
      },
      {
        "name": "Montserrat",
        "code": "MS",
        "dial_code": "+1664",
      },
      {
        "name": "????????????",
        "code": "MA",
        "dial_code": "+212",
      },
      {
        "name": "Mo??ambique",
        "code": "MZ",
        "dial_code": "+258",
      },
      {
        "name": "Myanmar",
        "code": "MM",
        "dial_code": "+95",
      },
      {
        "name": "Namibia",
        "code": "NA",
        "dial_code": "+264",
      },
      {
        "name": "Nauru",
        "code": "NR",
        "dial_code": "+674",
      },
      {
        "name": "???????????????",
        "code": "NP",
        "dial_code": "+977",
      },
      {
        "name": "Nederland",
        "code": "NL",
        "dial_code": "+31",
      },
      {
        "name": "Netherlands Antilles",
        "code": "AN",
        "dial_code": "+599",
      },
      {
        "name": "Nouvelle-Cal??donie",
        "code": "NC",
        "dial_code": "+687",
      },
      {
        "name": "New Zealand",
        "code": "NZ",
        "dial_code": "+64",
      },
      {
        "name": "Nicaragua",
        "code": "NI",
        "dial_code": "+505",
      },
      {
        "name": "Niger",
        "code": "NE",
        "dial_code": "+227",
      },
      {
        "name": "Nigeria",
        "code": "NG",
        "dial_code": "+234",
      },
      {
        "name": "Niu??",
        "code": "NU",
        "dial_code": "+683",
      },
      {
        "name": "Norfolk Island",
        "code": "NF",
        "dial_code": "+672",
      },
      {
        "name": "Northern Mariana Islands",
        "code": "MP",
        "dial_code": "+1670",
      },
      {
        "name": "Norge",
        "code": "NO",
        "dial_code": "+47",
      },
      {
        "name": "????????",
        "code": "OM",
        "dial_code": "+968",
      },
      {
        "name": "Pakistan",
        "code": "PK",
        "dial_code": "+92",
      },
      {
        "name": "Palau",
        "code": "PW",
        "dial_code": "+680",
      },
      {
        "name": "????????????",
        "code": "PS",
        "dial_code": "+970",
      },
      {
        "name": "Panam??",
        "code": "PA",
        "dial_code": "+507",
      },
      {
        "name": "Papua Niugini",
        "code": "PG",
        "dial_code": "+675",
      },
      {
        "name": "Paraguay",
        "code": "PY",
        "dial_code": "+595",
      },
      {
        "name": "Per??",
        "code": "PE",
        "dial_code": "+51",
      },
      {
        "name": "Pilipinas",
        "code": "PH",
        "dial_code": "+63",
      },
      {
        "name": "Pitcairn Islands",
        "code": "PN",
        "dial_code": "+64",
      },
      {
        "name": "Polska",
        "code": "PL",
        "dial_code": "+48",
      },
      {
        "name": "Portugal",
        "code": "PT",
        "dial_code": "+351",
      },
      {
        "name": "Puerto Rico",
        "code": "PR",
        "dial_code": "+1939",
      },
      {
        "name": "Puerto Rico",
        "code": "PR",
        "dial_code": "+1787",
      },
      {
        "name": "??????",
        "code": "QA",
        "dial_code": "+974",
      },
      {
        "name": "Rom??nia",
        "code": "RO",
        "dial_code": "+40",
      },
      {
        "name": "????????????",
        "code": "RU",
        "dial_code": "+7",
      },
      {
        "name": "Rwanda",
        "code": "RW",
        "dial_code": "+250",
      },
      {
        "name": "La R??union",
        "code": "RE",
        "dial_code": "+262",
      },
      {
        "name": "Saint-Barth??lemy",
        "code": "BL",
        "dial_code": "+590",
      },
      {
        "name": "Saint Helena",
        "code": "SH",
        "dial_code": "+290",
      },
      {
        "name": "Saint Kitts and Nevis",
        "code": "KN",
        "dial_code": "+1869",
      },
      {
        "name": "Saint Lucia",
        "code": "LC",
        "dial_code": "+1758",
      },
      {
        "name": "Saint-Martin",
        "code": "MF",
        "dial_code": "+590",
      },
      {
        "name": "Saint-Pierre-et-Miquelon",
        "code": "PM",
        "dial_code": "+508",
      },
      {
        "name": "Saint Vincent and the Grenadines",
        "code": "VC",
        "dial_code": "+1784",
      },
      {
        "name": "Samoa",
        "code": "WS",
        "dial_code": "+685",
      },
      {
        "name": "San Marino",
        "code": "SM",
        "dial_code": "+378",
      },
      {
        "name": "S??o Tom?? e Pr??ncipe",
        "code": "ST",
        "dial_code": "+239",
      },
      {
        "name": "?????????????? ????????????????",
        "code": "SA",
        "dial_code": "+966",
      },
      {
        "name": "S??n??gal",
        "code": "SN",
        "dial_code": "+221",
      },
      {
        "name": "????????????",
        "code": "RS",
        "dial_code": "+381",
      },
      {
        "name": "Seychelles",
        "code": "SC",
        "dial_code": "+248",
      },
      {
        "name": "Sierra Leone",
        "code": "SL",
        "dial_code": "+232",
      },
      {
        "name": "Singapore",
        "code": "SG",
        "dial_code": "+65",
      },
      {
        "name": "Slovensko",
        "code": "SK",
        "dial_code": "+421",
      },
      {
        "name": "Slovenija",
        "code": "SI",
        "dial_code": "+386",
      },
      {
        "name": "Solomon Islands",
        "code": "SB",
        "dial_code": "+677",
      },
      {
        "name": "Soomaaliya",
        "code": "SO",
        "dial_code": "+252",
      },
      {
        "name": "South Africa",
        "code": "ZA",
        "dial_code": "+27",
      },
      {
        "name": "South Sudan",
        "code": "SS",
        "dial_code": "+211",
      },
      {
        "name": "South Georgia",
        "code": "GS",
        "dial_code": "+500",
      },
      {
        "name": "Espa??a",
        "code": "ES",
        "dial_code": "+34",
      },
      {
        "name": "Sri Lanka",
        "code": "LK",
        "dial_code": "+94",
      },
      {
        "name": "??????????????",
        "code": "SD",
        "dial_code": "+249",
      },
      {
        "name": "Suriname",
        "code": "SR",
        "dial_code": "+597",
      },
      {
        "name": "Svalbard og Jan Mayen",
        "code": "SJ",
        "dial_code": "+47",
      },
      {
        "name": "Swaziland",
        "code": "SZ",
        "dial_code": "+268",
      },
      {
        "name": "Sverige",
        "code": "SE",
        "dial_code": "+46",
      },
      {
        "name": "Schweiz",
        "code": "CH",
        "dial_code": "+41",
      },
      {
        "name": "??????????",
        "code": "SY",
        "dial_code": "+963",
      },
      {
        "name": "??????",
        "code": "TW",
        "dial_code": "+886",
      },
      {
        "name": "????????????????????",
        "code": "TJ",
        "dial_code": "+992",
      },
      {
        "name": "Tanzania",
        "code": "TZ",
        "dial_code": "+255",
      },
      {
        "name": "???????????????????????????",
        "code": "TH",
        "dial_code": "+66",
      },
      {
        "name": "Timor-Leste",
        "code": "TL",
        "dial_code": "+670",
      },
      {
        "name": "Togo",
        "code": "TG",
        "dial_code": "+228",
      },
      {
        "name": "Tokelau",
        "code": "TK",
        "dial_code": "+690",
      },
      {
        "name": "Tonga",
        "code": "TO",
        "dial_code": "+676",
      },
      {
        "name": "Trinidad and Tobago",
        "code": "TT",
        "dial_code": "+1868",
      },
      {
        "name": "????????",
        "code": "TN",
        "dial_code": "+216",
      },
      {
        "name": "T??rkiye",
        "code": "TR",
        "dial_code": "+90",
      },
      {
        "name": "T??rkmenistan",
        "code": "TM",
        "dial_code": "+993",
      },
      {
        "name": "Turks and Caicos Islands",
        "code": "TC",
        "dial_code": "+1649",
      },
      {
        "name": "Tuvalu",
        "code": "TV",
        "dial_code": "+688",
      },
      {
        "name": "Uganda",
        "code": "UG",
        "dial_code": "+256",
      },
      {
        "name": "??????????????",
        "code": "UA",
        "dial_code": "+380",
      },
      {
        "name": "???????? ???????????????? ?????????????? ??????????????",
        "code": "AE",
        "dial_code": "+971",
      },
      {
        "name": "United Kingdom",
        "code": "GB",
        "dial_code": "+44",
      },
      {
        "name": "United States",
        "code": "US",
        "dial_code": "+1",
      },
      {
        "name": "Uruguay",
        "code": "UY",
        "dial_code": "+598",
      },
      {
        "name": "O???zbekiston",
        "code": "UZ",
        "dial_code": "+998",
      },
      {
        "name": "Vanuatu",
        "code": "VU",
        "dial_code": "+678",
      },
      {
        "name": "Venezuela",
        "code": "VE",
        "dial_code": "+58",
      },
      {
        "name": "Vi???t Nam",
        "code": "VN",
        "dial_code": "+84",
      },
      {
        "name": "British Virgin Islands",
        "code": "VG",
        "dial_code": "+1284",
      },
      {
        "name": "United States Virgin Islands",
        "code": "VI",
        "dial_code": "+1340",
      },
      {
        "name": "Wallis et Futuna",
        "code": "WF",
        "dial_code": "+681",
      },
      {
        "name": "??????????????",
        "code": "YE",
        "dial_code": "+967",
      },
      {
        "name": "Zambia",
        "code": "ZM",
        "dial_code": "+260",
      },
      {
        "name": "Zimbabwe",
        "code": "ZW",
        "dial_code": "+263",
      },
    ];

    return codes;
  }

}



