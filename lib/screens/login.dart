import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/logic/firebase/auth_service.dart';
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
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 10,
                  color: Theme.of(context).shadowColor,
                )
              ],
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(
                  MediaQuery.of(context).size.width * 3,
                  250,
                ),
              ),
            ),
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
                      'enklere',
                      'raskere',
                      'penere',
                      'ukeplan.'
                    ],
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      letterSpacing: 5,
                      wordSpacing: 0,
                    ),
                    onAnimate: (index) {
                      print("Animating index:" + index.toString());
                    },
                    onFinished: () {
                      print("Animtion finished");
                    },
                  ),
                );
              }())),
          LoginForm(
            emailController: emailController,
            passwordController: passwordController,
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: LoginButton(
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
                      child: LoginButton(
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

class LoginButton extends StatelessWidget {
  const LoginButton({
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
  analytics.logLogin();

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
        _LoginFormInputfield(
          node: node,
          controller: emailController,
          labelText: "Email",
          hintText: "bruker@kg.vgs.no",
          type: TextInputType.emailAddress,
          onFinish: () {
            print(node.nextFocus());
          },
        ),
        SizedBox(
          height: 15,
        ),
        _LoginFormInputfield(
          node: node,
          controller: passwordController,
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

class _LoginFormInputfield extends StatefulWidget {
  const _LoginFormInputfield({
    Key key,
    @required this.controller,
    @required this.labelText,
    @required this.hintText,
    @required this.onFinish,
    @required this.node,
    this.ispassword = false,
    this.textInputAction = TextInputAction.next,
    this.type = TextInputType.text,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function onFinish;
  final FocusNode node;

  final bool ispassword;
  final TextInputAction textInputAction;
  final TextInputType type;
  @override
  __LoginFormInputfieldState createState() {
    return __LoginFormInputfieldState(
        isHidden: (() {
      if (ispassword) {
        return true;
      }
      return false;
    }()));
  }
}

class __LoginFormInputfieldState extends State<_LoginFormInputfield> {
  __LoginFormInputfieldState({@required this.isHidden});
  bool isHidden;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: TextField(
          obscureText: isHidden,
          controller: widget.controller,
          keyboardType: widget.type,
          textInputAction: widget.textInputAction,
          onSubmitted: (value) {
            widget.onFinish();
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
              return Icon(Icons.email);
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