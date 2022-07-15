import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyButton extends StatelessWidget {
  final color;
  final buttonTapped;
  final String buttonText;
  final textColor;
  var alignment = 1.0;
  MyButton({this.color,this.buttonTapped,required this.buttonText,this.textColor,this.alignment=1});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: buttonTapped,
      child: Padding(
        padding: EdgeInsets.all(5),
          child: ClipRRect(

            // backgroundColor: color,
            // child: Text(buttonText),
            borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Container(
                alignment: Alignment.lerp(Alignment.centerLeft, Alignment.center, alignment),
                color:  color,
                // child: Center(
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: textColor,
                      // fontWeight: FontWeight.bold,
                      fontSize: 35
                  ),
                ),
              // ),
            ),
          ),
        ),
    );
  }
}
