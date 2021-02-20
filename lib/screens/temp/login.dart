import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/logic/firebase/auth_service.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.0),
        child: GestureDetector(
          onTap: () => print(" // TODO animation"),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(
                  MediaQuery.of(context).size.width * 4,
                  300,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 30,
                    letterSpacing: 5,
                    wordSpacing: 0,
                  ),
                ),
              ),
              LoginForm(
                emailController: emailController,
                passwordController: passwordController,
              ),
              SubmitButton(),
              SizedBox(
                height: 75,
              ) // TODO temp
            ],
          ),
        ],
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Container(
        height: 70,
        width: 350,
        child: Center(
          child: Text(
            "Sign In",
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
              fontSize: 25,
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
        login(context: context);
      },
    );
  }
}

void login({
  @required BuildContext context,
}) {
  print("h \n e \n r\n e");
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
