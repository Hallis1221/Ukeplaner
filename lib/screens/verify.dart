/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/elements/bottomCircle.dart';
import 'package:ukeplaner/logic/firebase/auth_services.dart';

int code;

class VerifyPage extends StatelessWidget {
  const VerifyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 25,
          ),
          LogoAndText(
            title: remoteConfig.getString("verifikasjon_tittel"),
            text: remoteConfig.getString("verifikasjon_tekst"),
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

class LogoAndText extends StatelessWidget {
  const LogoAndText({
    Key key,
    @required this.text,
    @required this.title,
  }) : super(key: key);

  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: 320,
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          SizedBox(height: 25),
          Container(
            height: 164,
            width: 164,
            child: Image.asset(
              'assets/images/logo1.png',
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.transparent,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                wordSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
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

class CodeInputter extends StatefulWidget {
  const CodeInputter({Key key}) : super(key: key);

  @override
  _CodeInputterState createState() => _CodeInputterState();
}

class _CodeInputterState extends State<CodeInputter>
    with SingleTickerProviderStateMixin {
  bool inputEnabled = true;
  bool buttonEnabled = true;
  bool validCode = false;

  // for å ikke prøve samme kode flere ganger
  List attemptedCodes = [];

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

    double size = MediaQuery.of(context).size.height / 100;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: size, right: size),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.5),
                child: Container(
                  width: 250,
                  child: PinCodeFields(
                    borderColor: Colors.grey,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    autoHideKeyboard: true,
                    activeBorderColor: Theme.of(context).primaryColor,
                    length: 4,
                    controller: codeInputController,
                    onComplete: (input) async {
                      if (attemptedCodes.contains(input)) {
                        allreadyTriedCode(context);
                        return;
                      }
                      try {
                        await VerificationSerivice()
                            .checkCode(int.parse(input))
                            .then((value) {
                          setState(() {
                            validCode = value;
                            inputEnabled = !value;
                            buttonEnabled = !value;
                            attemptedCodes.add(input);
                            if (value == false) {
                              animationController.forward(from: 0.0);
                            }
                          });
                        });
                      } catch (e) {
                        animationController.forward(from: 0.0);
                        codeInputController.clear();
                      }
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
                        if (validCode && validCode != null) {
                          switchScreen();
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
                  return () async {
                    String input = codeInputController.text;
                    if (attemptedCodes.contains(input)) {
                      allreadyTriedCode(context);
                      return;
                    }
                    try {
                      await VerificationSerivice()
                          .checkCode(int.parse(input))
                          .then((value) {
                        setState(() {
                          validCode = value;
                          inputEnabled = !value;
                          buttonEnabled = !value;
                          attemptedCodes.add(input);
                          if (value = false) {
                            animationController.forward(from: 0.0);
                          }
                        });
                      });
                    } catch (e) {
                      animationController.forward(from: 0.0);
                      codeInputController.clear();
                    }
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

  void switchScreen() async {
    code = int.parse(codeInputController.text);
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushNamed(context, "/register");
    attemptedCodes.remove(codeInputController.text);
    codeInputController.clear();
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      validCode = false;
      inputEnabled = true;
      buttonEnabled = false;
    });
  }

  void allreadyTriedCode(BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: Text("Du har allerede prøvd denne koden!"),
    ));
    animationController.forward(from: 0.0);
  }
}
