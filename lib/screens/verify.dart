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

class CodeInputter extends StatelessWidget {
  const CodeInputter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    onComplete: (value) {
                      print(value);
                    },
                  ),
                ),
              ),
              Icon(
                Icons.check_circle,
                color: Color.fromARGB(255, 58, 204, 108),
              )
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 25, right: 25, left: 25),
          child: Center(
            child: TextButton(
              onPressed: () => print("hello world"),
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
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(150.0),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  )),
            ),
          ),
        )
      ],
    );
  }
}
