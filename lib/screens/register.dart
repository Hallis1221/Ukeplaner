import 'package:flutter/material.dart';
import 'package:ukeplaner/config/config.dart';
import 'login.dart' as l;
import 'verify.dart';

TextEditingController emailController = TextEditingController();
TextEditingController verifyEmailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController firstnameController = TextEditingController();
TextEditingController lastnameController = TextEditingController();

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250),
        child: Stack(
          children: [
            l.TopDecorationHalfCircle(),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              "Registrering",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                letterSpacing: 5,
                wordSpacing: 0,
              ),
            ),
          ),
          RegisterForm(
            node: node,
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
            ),
            child: l.LoginButton(
              title: "Registrer",
              height: 70,
              fontSize: 25,
              onPressed: () {
                print(code);
                print(firstnameController.text);
                print(lastnameController.text);
                print(emailController.text);
                print(passwordController.text);
              },
            ),
          ),
          SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key key,
    @required this.node,
  }) : super(key: key);

  final FocusScopeNode node;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 33,
            left: 33,
          ),
          child: FirstNameLastName(
            widget: widget,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        l.FormInputField(
          icon: Icon(Icons.email),
          hintText: "bruker@${website.replaceAll("https://", "")}",
          controller: emailController,
          labelText: "Email",
          onFinish: () {
            setState(() {
              emailController.text = emailController.text;
            });
            widget.node.nextFocus();
          },
          onChange: () {},
          type: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(
          height: 15,
        ),
        l.FormInputField(
          icon: Icon(Icons.visibility),
          hintText: "123456",
          controller: passwordController,
          labelText: "Passord",
          ispassword: true,
          onFinish: () {
            widget.node.unfocus();
          },
          type: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

class FirstNameLastName extends StatelessWidget {
  const FirstNameLastName({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final RegisterForm widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        l.FormInputField(
          icon: Icon(Icons.person),
          hintText: "Ola",
          labelText: "Fornavn",
          controller: firstnameController,
          width: MediaQuery.of(context).size.width / 2.45,
          onFinish: () {
            widget.node.nextFocus();
          },
          type: TextInputType.name,
          textInputAction: TextInputAction.next,
        ),
        Expanded(
          child: SizedBox(),
        ),
        l.FormInputField(
          icon: Icon(Icons.person),
          controller: lastnameController,
          hintText: "Nordmann",
          labelText: "Etternavn",
          width: MediaQuery.of(context).size.width / 2.45,
          onFinish: () {
            widget.node.nextFocus();
          },
          type: TextInputType.name,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
