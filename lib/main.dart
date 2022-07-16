import 'package:calculator/services/MyButton.dart';
import 'package:flutter/material.dart';
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
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
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
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // GestureDetector(
                      //   onHorizontalDragEnd: (DragEndDetails details) {
                      //     print(
                      //         "Drag End : ${details.velocity.pixelsPerSecond.dx}");
                      //     setState(() {
                      //       if (details.velocity.pixelsPerSecond.dx > 0 ||
                      //           details.velocity.pixelsPerSecond.dx < 0) {
                      //         userInput =
                      //             userInput.substring(0, userInput.length - 1);
                      //       }
                      //     });
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.fromLTRB(20, 20, 40, 20),
                      //     alignment: Alignment.centerRight,
                      //     child: Text(userInput,
                      //         style:
                      //             TextStyle(fontSize: 20, color: Colors.white)),
                      //   ),
                      // ),
                      GestureDetector(
                        onHorizontalDragEnd: (DragEndDetails details) {
                          print(
                              "Drag End : ${details.velocity.pixelsPerSecond.dx}");
                          setState(() {
                            if (details.velocity.pixelsPerSecond.dx > 0 ||
                                details.velocity.pixelsPerSecond.dx < 0) {
                              result =
                                  result.substring(0, result.length - 1);
                            }
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.all(15),
                            alignment: Alignment.centerRight,
                            child: Text(
                              result,
                              style: TextStyle(
                                fontSize: result.length > 6 ? 50 : 100,
                                color: Colors.white,
                                // fontWeight: FontWeight.bold
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              // ),
              Expanded(
                  flex: 3,
                  child: Container(
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
                              buttonText: buttons[index],
                              color: Colors.grey.shade500,
                              textColor: Colors.black,
                              buttonTapped: () {
                                setState(() {
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
                                  userInput +='+ ${result}';
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
                                            userInput[userInput.length-2]) &&
                                        userInput != null) {
                                      result = '';
                                      result += buttons[index];
                                    } else {
                                      result +=buttons[index];
                                    }
                                  } else {
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
                  ))
            ],
          ),
        ));
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
