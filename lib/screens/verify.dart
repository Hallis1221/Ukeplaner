import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';

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
                      await checkCode(int.parse(input)).then((value) {
                        setState(() {
                          validCode = value;
                          inputEnabled = !value;
                          buttonEnabled = !value;
                          attemptedCodes.add(input);
                        });
                      });
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
                    await checkCode(int.parse(input)).then((value) {
                      setState(() {
                        validCode = value;
                        inputEnabled = !value;
                        buttonEnabled = !value;
                        attemptedCodes.add(input);
                        print(attemptedCodes);
                      });
                    });
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

  Future<bool> checkCode(int input) async {
    FirebaseFunctions.instance
        .useFunctionsEmulator(origin: 'http://localhost:5001');

    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('checkcode');
    final results = await callable.call(<String, int>{"code": input});
    // planen var egt å bare hente alle kodene, men da ville appen vært enkel å bryte seg inn i
    return results.data;
  }
}
