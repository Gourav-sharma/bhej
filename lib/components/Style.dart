import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ColorResource.dart';
import 'ImageResource.dart';

class Style {

 static const CircularProgressIndicator circularProgressIndicator = CircularProgressIndicator(backgroundColor: Color(0xffdf9036));



  static Widget getprefixIcon(String imageIcon) {
    return Container(
      width: 40,
      margin: EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      // child: Icon(Icons.email, size: 26.0, color: Colors.grey),
      child: Image.asset(imageIcon, width: 20, height: 20),
    );
  }

  static InputDecoration inputDecorationPlan(String hintText, {required String suffixText}) {
    return InputDecoration(
        hintStyle: TextStyle(fontSize: 14),
        hintText: hintText,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        counterStyle: TextStyle(
          height: double.minPositive,
        ),
        counterText: "",
        suffixText: suffixText,
        suffixStyle: TextStyle(color: ColorResource.white));
  }

  static int left_input_box_weight = 2;
  static int right_input_box_weight = 3;

  static TextStyle label(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.merge(TextStyle(fontSize: 14, fontWeight: FontWeight.w300));
  }
}
