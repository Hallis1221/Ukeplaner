import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class VerifyPage extends StatelessWidget {
  const VerifyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 25,
          ),
          Container(
            height: 280,
            width: 320,
            color: Colors.red,
          ),
          InputCard(),
          SizedBox(
            height: 50,
          ),
          BottomCircle(),
        ],
      ),
    );
  }
}

class InputCard extends StatelessWidget {
  const InputCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 0,
                bottom: 25.0,
                left: 25.0,
                right: 25.0,
              ),
              child: Card(
                elevation: 2,
                child: ClipPath(
                  child: Container(
                    child: CodeInputter(),
                  ),
                  clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomCircle extends StatelessWidget {
  const BottomCircle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 10,
            color: Theme.of(context).shadowColor,
          )
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.elliptical(
            MediaQuery.of(context).size.width * 3,
            250,
          ),
        ),
      ),
    );
  }
}

class CodeInputter extends StatefulWidget {
  const CodeInputter({Key key}) : super(key: key);

  @override
  _CodeInputterState createState() => _CodeInputterState();
}

class _CodeInputterState extends State<CodeInputter>
    with SingleTickerProviderStateMixin {
  bool validCode = false;
  bool inputEnabled = true;
  bool buttonEnabled = false;

  AnimationController animationController;
  TextEditingController codeInputController = TextEditingController();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 2.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animationController.reverse();
            }
          });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.5),
                child: Container(
                  width: 250,
                  child: PinCodeFields(
                    borderColor: Colors.grey,
                    keyboardType: TextInputType.number,
                    activeBorderColor: Theme.of(context).primaryColor,
                    length: 4,
                    controller: codeInputController,
                    onComplete: (value) {
                      setState(() {
                        inputEnabled = false;
                      });
                      checkCode(value);
                    },
                    enabled: inputEnabled,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: offsetAnimation,
                builder: (context, child) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: offsetAnimation.value + 2.0,
                        right: 2.0 - offsetAnimation.value),
                    child: Icon(
                      (() {
                        if (validCode) {
                          return Icons.check_circle;
                        }
                        return Icons.error_outlined;
                      }()),
                      color: (() {
                        if (validCode) {
                          return Colors.green;
                        }
                        return Colors.red;
                      }()),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 25, right: 25, left: 25),
          child: Center(
            child: RaisedButton(
              onPressed: (() {
                if (buttonEnabled) {
                  return () {
                    checkCode(codeInputController.text);
                  };
                }
                return null;
              }()),
              child: Container(
                width: 350,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(7.5),
                    child: Text(
                      "Sjekk",
                      style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(150.0),
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void checkCode(String input) {
    Future<void> getFruit() async {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('listFruit');
      final results = await callable.call();
      List fruit = results
          .data; // ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]
      print(fruit);
    }

    getFruit();
    // planen var egt å bare hente alle kodene, men da ville appen vært enkel å bryte seg inn i
    String code = "1234";
    setState(() {
      validCode = input == code;

      if (validCode) {
      } else {
        animationController.forward(from: 0.0);
        inputEnabled = true;
        buttonEnabled = true;
      }
    });
    print(input);
  }
}
