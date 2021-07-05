
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bhej/components/ColorResource.dart';
import 'package:bhej/environment/environment.dart';


class MyButton extends StatelessWidget {
  final String? text;
  final Color? color;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final double? width;
  final Function()? onPressed;

  MyButton({@required this.text, @required this.onPressed, this.leftIcon, this.rightIcon, this.color = ColorResource.buttonColor, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: width != null ? width : widthScrren,

      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: RaisedButton(
        elevation: 0,
          color: color,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),

          ),
          child: Row(
            children: <Widget>[
              leftIcon != null
                  ? Icon(
                      leftIcon,
                      color: Colors.white,
                    )
                  : Container(),
              Expanded(
                  child: Text(text!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                          wordSpacing: 2,
                        fontFamily: FontResource.FONT_HELVETICANEUE
                      )),
                  flex: 1),
              rightIcon != null
                  ? Icon(
                      rightIcon,
                      color: Colors.white,
                    )
                  : Container(),
            ],
          )),
    );
  }
}
