/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../config/config.dart';
import '../elements/TopDecorationHalfCircle.dart';

import '../logic/firebase/auth_services.dart';
import 'package:animated_text/animated_text.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool animatedText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              animatedText = !animatedText;
            });

            print(
              " // TODO animation ",
            );
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              TopDecorationHalfCircle(),
              Padding(
                padding: const EdgeInsets.only(top: 60.0, right: 15.0),
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/welcome'),
                  child: Icon(
                    Icons.help,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: (() {
                if (!animatedText) {
                  return Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      letterSpacing: 5,
                      wordSpacing: 0,
                    ),
                  );
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: AnimatedText(
                    alignment: Alignment.center,
                    speed: Duration(milliseconds: 1000),
                    controller: AnimatedTextController.loop,
                    displayTime: Duration(milliseconds: 1000),
                    wordList: [
                      'Login for en',
                      'Enklere',
                      'Raskere',
                      'Penere',
                      'Ukeplan'
                    ],
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      letterSpacing: 5,
                      wordSpacing: 0,
                    ),
                    onAnimate: (index) {},
                    onFinished: () {},
                  ),
                );
              }())),
          Column(
            children: [
              LoginForm(
                emailController: emailController,
                passwordController: passwordController,
              ),
              ForgotPassword()
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: PurpleButton(
                  title: "Login",
                  height: 70,
                  fontSize: 25,
                  onPressed: () => login(
                    context: context,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Eller",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    letterSpacing: 2,
                    wordSpacing: 0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: PurpleButton(
                          title: "Registrer deg med en kode",
                          height: 40,
                          fontSize: 20,
                          onPressed: () => Navigator.pushNamed(
                                context,
                                "/verify",
                              )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () {
          if (emailController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text("Skriv inn en email for å resete passordet ditt!"),
              ),
            );
          }
          context
              .read<AuthenticationService>()
              .resetCurrentUserPassword(context, email: emailController.text);
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 36.0,
              top: 5,
            ),
            child: Text(
              "Glemt passord?",
              style: TextStyle(
                color: Color.fromARGB(255, 229, 25, 25),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PurpleButton extends StatelessWidget {
  const PurpleButton({
    Key key,
    @required this.title,
    @required this.onPressed,
    this.height,
    this.width,
    this.fontSize,
  }) : super(key: key);

  final String title;
  final Function onPressed;
  final double height;
  final double width;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          )),
      onPressed: () {
        onPressed();
      },
    );
  }
}

void login({
  @required BuildContext context,
}) {
  context
      .read<AuthenticationService>()
      .signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
      .then((value) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value.toString().trim()))));
  passwordController.clear();
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key key,
    @required this.emailController,
    @required this.passwordController,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Column(
      children: [
        FormInputField(
          controller: emailController,
          icon: Icon(Icons.email),
          labelText: "Email",
          hintText: "bruker@${website.replaceAll("https://", "")}",
          type: TextInputType.emailAddress,
          onFinish: () {
            node.nextFocus();
          },
        ),
        SizedBox(
          height: 15,
        ),
        FormInputField(
          controller: passwordController,
          icon: Icon(Icons.visibility),
          labelText: "Passord",
          hintText: "123456",
          ispassword: true,
          type: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          onFinish: () {
            node.unfocus();
            login(context: context);
          },
        ),
      ],
    );
  }
}

class FormInputField extends StatefulWidget {
  const FormInputField({
    Key key,
    @required this.controller,
    @required this.labelText,
    @required this.hintText,
    @required this.onFinish,
    @required this.icon,
    this.width,
    this.onChange,
    this.ispassword = false,
    this.textInputAction = TextInputAction.next,
    this.type = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function onFinish;
  final Function onChange;

  final double width;
  final bool ispassword;
  final int maxLines;
  final Icon icon;
  final TextInputAction textInputAction;
  final TextInputType type;
  @override
  _FormInputFieldState createState() {
    return _FormInputFieldState(
        isHidden: (() {
      if (ispassword) {
        return true;
      }
      return false;
    }()));
  }
}

class _FormInputFieldState extends State<FormInputField> {
  _FormInputFieldState({@required this.isHidden});
  bool isHidden;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: (() {
          if (widget.width == null) {
            return MediaQuery.of(context).size.width / 1.2;
          }
          return widget.width;
        }()),
        child: TextField(
          maxLines: (() {
            if (widget.ispassword) {
              return 1;
            } else {
              return widget.maxLines;
            }
          }()),
          obscureText: isHidden,
          controller: widget.controller,
          keyboardType: widget.type,
          textInputAction: widget.textInputAction,
          onSubmitted: (value) {
            try {
              widget.onFinish();
            } catch (e) {}
          },
          onChanged: (value) {
            try {
              widget.onChange();
            } catch (e) {}
          },
          onEditingComplete: () => widget.onFinish,
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            filled: false,
            suffix: (() {
              if (widget.ispassword) {
                return InkWell(
                  splashColor: Colors.transparent,
                  child: Icon((() {
                    if (isHidden) {
                      return Icons.visibility;
                    }
                    return Icons.visibility_off;
                  }())),
                  onTap: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                );
              }
              return widget.icon;
            }()),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  10,
                ),
              ),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  10,
                ),
              ),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
