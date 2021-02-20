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
      resizeToAvoidBottomInset: false,
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
              TextButton(
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
                  analytics.logLogin();

                  context
                      .read<AuthenticationService>()
                      .signIn(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      )
                      .then((value) => ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                              content: Text(value.toString().trim()))));
                  passwordController.clear();
                },
              ),
            ],
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
      ],
    );
  }
}
