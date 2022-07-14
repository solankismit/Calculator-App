import 'package:calculator/services/MyButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'Schyler'
      ),
        home: Calculator()));
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var userInput = '';
  var result = '';

  final List<String> buttons = [
    'AC',
    '+/-',
    '%',
    '/',
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
    'X',
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Calculator', style: TextStyle(fontSize: 50)),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onHorizontalDragEnd: (DragEndDetails) {
                  print("HORIZONTAL DETECTED");
                  setState(() {
                    userInput = userInput.substring(0, userInput.length - 1);
                  });
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.centerRight,
                        child: Text(userInput,
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                      Container(
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.centerRight,
                          child: Text(
                            result,
                            style: TextStyle(
                              fontSize: 70,
                              color: Colors.white,
                              // fontWeight: FontWeight.bold
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(1),
                  child: GridView.builder(
                      itemCount: buttons.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),

                      itemBuilder: (BuildContext context, int index) {
                        //Clear Button
                        if (index == 0) {
                          return MyButton(
                            buttonText: buttons[index],
                            color: Colors.grey.shade400,
                            textColor: Colors.black,
                            buttonTapped: () {
                              setState(() {
                                userInput = '0';
                                result = '0';
                              });
                            },
                          );
                        }

                        //+/- Button
                        else if (index == 1) {
                          return MyButton(
                            buttonText: buttons[index],
                            color: Colors.grey.shade400,
                            textColor: Colors.black,
                            buttonTapped: () {
                              setState(() {
                                userInput = userInput.replaceRange(
                                                0, userInput.length, Negate(userInput));
                              });
                            },
                          );
                        }

                        //+- button
                        // if (index == 18) {
                        //   return MyButton(
                        //     buttonText: buttons[index],
                        //     color: Colors.grey[400],
                        //     textColor: Colors.black,
                        //     buttonTapped: () {
                        //       setState(() {
                        //         userInput = userInput.replaceRange(
                        //             0, userInput.length, Negate(userInput));
                        //       });
                        //     },
                        //   );
                        // }
                        //Equal Button
                        else if (index == 18) {
                          return MyButton(
                            buttonText: buttons[index],
                            color: Colors.orange[700],
                            textColor: Colors.white,
                            buttonTapped: () {
                              setState(() {
                                equalPressed();
                              });
                            },
                          );
                        } else if (index == 2) {
                          return MyButton(
                            buttonText: buttons[index],
                            color: Colors.grey[400],
                            textColor: Colors.black,
                            buttonTapped: () {
                              setState(() {
                                userInput =
                                    OperatorAdder(userInput, buttons[index]);
                              });
                            },
                          );
                        } else {
                          return MyButton(
                            buttonTapped: () {
                              setState(() {
                                if (!isOperator(buttons[index])) {
                                  userInput += buttons[index];
                                } else {
                                  userInput =
                                      OperatorAdder(userInput, buttons[index]);
                                }
                              });
                            },
                            textColor: Colors.white,
                            buttonText: buttons[index],
                            color: isOperator(buttons[index])
                                ? Colors.amber.shade600
                                : Colors.grey[800],
                          );
                        }
                      }),
                ))
          ],
        ));
  }

  bool isOperator(String str) {
    if (str == '%' || str == '/' || str == '+' || str == '-' || str == 'X') {
      return true;
    }
    return false;
  }

  String OperatorAdder(String str, String btn) {
    if (isOperator(str[str.length - 1])) {
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

  void equalPressed() {
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('X', '*');

    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    result = eval.toString();
  }
}
