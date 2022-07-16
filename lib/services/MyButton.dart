import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyButton extends StatelessWidget {
  final color;
  final buttonTapped;
  final String buttonText;
  final textColor;
  // var alignment = 1.0;
  MyButton({this.color,this.buttonTapped,required this.buttonText,this.textColor});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(

      padding: buttonText=='0'?EdgeInsets.only(right: 100):EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(60))),
      onPressed: buttonTapped,
      color: color,

      // child: Padding(
        // padding: EdgeInsets.all(7),
        //   child: ClipRRect(

            // backgroundColor: color,
            // child: Text(buttonText),
            // borderRadius: BorderRadius.all(Radius.circular(50)),
            //   child: Container(
            //     alignment: Alignment.lerp(Alignment.centerLeft, Alignment.center, alignment),
            //     color:  color,
                // child: Center(
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: textColor,

                      fontWeight: FontWeight.w600,
                      fontSize: 30
                  ),
                ),
              // ),
            // ),
          // ),
        // ),
    );
  }
}
