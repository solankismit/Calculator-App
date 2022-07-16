import 'package:calculator/services/MyButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:math_expressions/math_expressions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
      MaterialApp(theme: ThemeData(fontFamily: 'Schyler'), home: Calculator()));
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var userInput = '';
  var result = '';
  var selectedOpr = '';
  var temp = '';
  var tempres = '';
  dynamic clearbtn = 'AC';
  final List<String> buttons = [
    'AC',
    '+/-',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '+',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '×',
    '0',
    '.',
    // '+-',
    '='
  ];

  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
        appBar: AppBar(
          // title: Text('Calculator', style: TextStyle(fontSize: 50)),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Expanded(
              //   flex: 1,
                // child: SizedBox.expand(

                // onHorizontalDragEnd: (DragEndDetails details) {
                //   if (details.primaryVelocity! < 0) {
                //     // User swiped Right{
                //     print("HORIZONTAL DETECTED");
                //     setState(() {
                //       userInput =
                //           userInput.substring(0, userInput.length - 1);
                //     });
                //   }
                // },
              Container(
                // constraints: BoxConstraints(minHeight: 10,minWidth: width,maxHeight: height,maxWidth: width),
                // alignment: AlignmentDirectional.topCenter,
                // height: height*0.27,
                // width: width,
                child:
                      GestureDetector(
                        onHorizontalDragEnd: (DragEndDetails details) {
                          print(
                              "Drag End : ${details.velocity.pixelsPerSecond.dx}");
                          setState(() {
                            if (details.velocity.pixelsPerSecond.dx > 0 ){
                              tempres = result;
                              result = result.substring(0, result.length - 1);
                              temp += tempres[tempres.length-1];
                              print("Swipe 1");
                              print(temp);
                            }
                               if ( details.velocity.pixelsPerSecond.dx < 0 && temp!='') {
                                 print("Swipe 2");
                              print("Before Swipe 2 : $temp");
                              result +=temp[temp.length-1];
                              temp=temp.substring(0,temp.length-1);
                              print("After Swipe 2 : $temp");
                            }
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.fromLTRB(10, 7, 10, 0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              result,
                              style: TextStyle(
                                fontSize: result.length > 5 ? 70 : 100,
                                color: Colors.white,
                                // fontWeight: FontWeight.bold
                              ),
                            )),
                      ),),
              // Expanded(
              //     flex: 2,
              //     child:
                  Container(
                    // width: width,
                    // alignment: Alignment.bottomCenter,
                    height: height*0.6,
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(5),
                    child: StaggeredGridView.countBuilder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: buttons.length,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 5,
                        crossAxisCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          //Clear Button
                          if (index == 0) {
                            return MyButton(
                              buttonText: result.length>0 ? 'C' : clearbtn,
                              color: Colors.grey.shade500,
                              textColor: Colors.black,
                              buttonTapped: () {
                                setState(() {
                                  clearbtn = 'AC';
                                  temp = '';
                                  selectedOpr = '';
                                  userInput = '';
                                  result = '';
                                });
                              },
                            );
                          }

                          //+/- Button
                          else if (index == 1) {
                            return MyButton(
                              buttonText: buttons[index],
                              color: Colors.grey.shade500,
                              textColor: Colors.black,
                              buttonTapped: () {
                                setState(() {
                                  userInput = userInput.replaceRange(
                                      0, userInput.length, Negate(userInput));
                                  result = result.replaceRange(0, result.length, Negate(result));
                                });
                              },
                            );
                          }
                          //Equal Button
                          else if (index == 18) {
                            return MyButton(
                              buttonText: buttons[index],
                              color: Colors.orange[700],
                              textColor: Colors.white,
                              buttonTapped: () {
                                setState(() {
                                  selectedOpr = '';
                                  temp='';
                                  equalPressed();
                                });
                              },
                            );
                          }
                          //% Button
                          else if (index == 2) {
                            return MyButton(
                              buttonText: buttons[index],
                              color: Colors.grey[500],
                              textColor: Colors.black,
                              buttonTapped: () {
                                setState(() {
                                  // userInput =
                                  //     OperatorAdder(userInput, buttons[index]);
                                  result = ((double.parse(result))*0.01).toString();
                                  userInput += '-${double.parse(result)*100}';
                                  userInput +='+ $result';
                                  print(userInput);
                                  print(result);
                                });
                              },
                            );
                          } else {
                            return MyButton(
                              buttonTapped: () {
                                setState(() {
                                  if (!isOperator(buttons[index])) {
                                    userInput += buttons[index];
                                    if (result == '') {
                                      result += buttons[index];
                                    } else if (isOperator(
                                            userInput[userInput.length-2])) {
                                      result = '';
                                      result += buttons[index];
                                    } else {
                                      result +=buttons[index];
                                    }
                                  }
                                  else if(result.length==0){result = 'Error';}
                                  else {
                                    selectedOpr = buttons[index];
                                    userInput =
                                        OperatorAdder(userInput, buttons[index]);
                                  }
                                });
                              },
                              textColor: isOperator(buttons[index])
                                  ? selectedOpr == buttons[index]
                                      ? Colors.black
                                      : Colors.white
                                  : Colors.white,
                              buttonText: buttons[index],
                              color: isOperator(buttons[index])
                                  ? selectedOpr == buttons[index]
                                      ? Colors.white
                                      : Colors.amber.shade800
                                  : Colors.grey[900],
                            );
                          }
                        },
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.count(index == 16 ? 2 : 1, 1)),
                  )
            ],
          ),
        );
  }

  bool isOperator(String str) {
    if (str == '÷' || str == '+' || str == '-' || str == '×') {
      return true;
    }
    return false;
  }

  String OperatorAdder(String str, String btn) {
    if (isOperator(str[str.length - 1]) || (str[str.length-1] == '%' && btn == '%')) {
      return str.replaceRange(str.length - 1, str.length, btn);
    } else {
      return userInput + btn;
    }
  }

  String Negate(String userInput) {
    if (userInput[0] == '-') {
      return userInput.substring(1);
    } else
      return '-' + userInput;
  }
  String equalPressed() {
    if (isOperator(userInput[userInput.length - 1])) {
      result = 'Error';
      return result;
    }
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('×', '*');
    finaluserinput = finaluserinput.replaceAll('÷', '/');
    print(finaluserinput);
    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    result = eval.toString();

    return result;
  }
}
