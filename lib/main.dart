import 'package:calculator/services/MyButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MaterialApp(
      theme: ThemeData(fontFamily: 'Schyler'), home: const Calculator()));
}

class Calculator extends StatefulWidget {

  const Calculator({Key? key}) : super(key: key);
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  int count = 0;
  var userInput = '';
  var result = '0';
  var selectedOpr = '';
  var temp = '';
  var tempres = '';
  bool mod = false;
  dynamic clearbtn = 'AC';
  final List<String> buttons = [
    'AC',
    '+/-',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    '='
  ];

  @override
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              // print(
              //     "Drag End : ${details.velocity.pixelsPerSecond.dx}");
              setState(() {
                if (details.velocity.pixelsPerSecond.dx > 0) {
                  tempres = result;
                  result = result.substring(0, result.length - 1);
                  userInput = userInput.substring(0, userInput.length - 1);
                  temp += tempres[tempres.length - 1];
                  if (result == '') {
                    temp = '';
                  }
                  // print("Swipe 1");
                  // print(temp);
                } else if (details.velocity.pixelsPerSecond.dx < 0 &&
                    temp != '') {
                  // print("Swipe 2");
                  // print("Before Swipe 2 : $temp");
                  result += temp[temp.length - 1];
                  userInput += temp[temp.length - 1];
                  temp = temp.substring(0, temp.length - 1);
                  // print("After Swipe 2 : $temp");
                }
              });
            },
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 7, 10, 0),
                alignment: Alignment.centerRight,
                child: SelectableText(
                  result,
                  toolbarOptions: ToolbarOptions(
                      copy: true, cut: true, paste: true, selectAll: true),
                  style: TextStyle(
                    fontSize: result.length > 5 ? 70 : 100,
                    color: Colors.white,
                    // fontWeight: FontWeight.bold
                  ),
                )),
          ),
          // Expanded(
          //     flex: 2,
          //     child:
          Container(
            // width: width,
            // alignment: Alignment.bottomCenter,
            height: height * 0.6,
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
                      buttonText: int.parse(result.replaceAll('.', ''))==0 ? 'AC' : clearbtn,
                      color: Colors.grey.shade500,
                      textColor: Colors.black,
                      buttonTapped: () {
                        setState(() {
                          clearbtn = 'C';
                          temp = '';
                          selectedOpr = '';
                          userInput = '';
                          result = '0';
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
                          // userInput = userInput.replaceRange(
                          //     0, userInput.length, Negate(userInput));
                          result = result.replaceRange(
                              0, result.length, Negate(result));
                          userInput = userInput + '+($result) $result';
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
                          temp = '';
                          result = equalPressed();
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
                          result = ((double.parse(result)) * 0.01).toString();
                          userInput += '-${double.parse(result) * 100}';
                          userInput += '+ $result';
                          mod = true;
                          // print(userInput);
                          // print(result);
                        });
                      },
                    );
                  } else {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          if (!isOperator(buttons[index])) {
                            if (result.length <= 12) {
                              if (mod) {
                                result = '';
                                userInput += '×' + buttons[index];
                                result +=buttons[index];
                                mod = false;
                              } else {
                                userInput += buttons[index];
                                if (buttons[index] == '.') {
                                  if(result.contains('.')){
                                    print('in dot');
                                    userInput = userInput.substring(
                                        0, userInput.length - 2);
                                    result = result;
                                  }
                                  else{
                                    if(result == ''){result+='0'+buttons[index];}
                                    else{result+=buttons[index];}
                                  }
                                }
                                else if(result[result.length-1]=='.'){
                                  result+=buttons[index];
                                }
                                else if (result == '' ||
                                    int.parse(result.replaceAll('.', '')) ==
                                        0) {
                                  print('in parse');
                                  result = '';
                                  result += buttons[index];
                                } else if (isOperator(
                                    userInput[userInput.length - 2])) {
                                  result = '';
                                  result += buttons[index];
                                }
                                // else if (buttons[index]=='.' && result.contains('.')){
                                //   print('in dot');
                                //     result = result;
                                // }
                                else {
                                  result += buttons[index];
                                }
                              }
                            } else {
                              showToast();
                            }
                          } else if (result.length == 0) {
                            result = 'Error';
                          } else {
                            selectedOpr = buttons[index];
                            mod = false;
                            userInput =
                                OperatorAdder(userInput, buttons[index]);
                          }
                        });
                      },
                      textColor: isOperator(buttons[index])
                          ? selectedOpr == buttons[index]
                              ? Colors.amber.shade800
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
    if (isOperator(str[str.length - 1]) ||
        (str[str.length - 1] == '%' && btn == '%')) {
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
    String result;
    print("Equal Called");
    if (isOperator(userInput[userInput.length - 1])) {
      result = 'Error';
      return result;
    }
    RegExp regex = RegExp(r"([.]*0+)(?!.*\d)");
    // print("In P-1");
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('×', '*');
    print(finaluserinput);
    finaluserinput = finaluserinput.replaceAll('÷', '/');
    print(finaluserinput);
    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    print(exp);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    result = eval
        .toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 10)
        .replaceAll(regex, '');

    return result;
  }

  void showToast(){
    Fluttertoast.showToast(
        msg: "Can't Enter more than 13 digits",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade600,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
