
import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/ui/Inbox/inboxpage.dart';
import 'package:bhej/ui/Login/UserModel.dart';
import 'package:bhej/ui/allusers/AllUsersPage.dart';
import 'package:bhej/ui/chatscreen/ChatActivity.dart';
import 'package:bhej/ui/chatscreen/ChatMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class UserListItem {
  UserModel? model = null;
  late BuildContext context;
  late  AllUsersPageState pageState;
  UserListItem(model,context,pageState){
    this.model = model;
    this.context = context;
    this.pageState = pageState;
  }
  Widget ListItem(){
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap:  (){
          print("tapped");
          pageState.naviGatePage(model);
        },
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: Image.network(
                          model!.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) {
                            return Image.asset(
                                'assets/images/no_img.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.fitWidth);
                          },
                        )
                    ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(model!.name, style: TextStyle(color: ColorResource.black_text , fontSize: 16),)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 20,top: 5),
                        child: Text(model!.getBio(), style: TextStyle(color: ColorResource.gray , fontSize: 12),)
                    ),
                  ],

                ),

              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50, 10, 0, 0),
              decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ColorResource.gray.withOpacity(0.5)
                    ),
                  )),
            ),
          ],

        ),
      ),
    );
  }
}