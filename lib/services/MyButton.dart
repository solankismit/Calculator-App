import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class MyButton extends StatelessWidget {
  final color;
  final buttonTapped;
  final String buttonText;
  final textColor;
  // var alignment = 1.0;
  MyButton(
      {this.color,
      this.buttonTapped,
      required this.buttonText,
      this.textColor});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: buttonText == '0' ? EdgeInsets.only(right: 90) : EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(60))),
      onPressed:
        buttonTapped
        // HapticFeedback.lightImpact();
        ,
      color: color,
      enableFeedback: true,
      child: Text(
        buttonText,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w600, fontSize: 30),
      ),
      // ),
      // ),
      // ),
      // ),
    );
  }
}
