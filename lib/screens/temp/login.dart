import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/logic/firebase/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.0),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Login", sty),
          ),
          LoginForm(
            emailController: emailController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
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
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: "Password",
          ),
        ),
        ElevatedButton(
          child: Text("Sign In"),
          onPressed: () {
            analytics.logLogin();
            context
                .read<AuthenticationService>()
                .signIn(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                )
                .then((value) => Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(value.toString().trim()))));
          },
        ),
      ],
    );
  }
}
