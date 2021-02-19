import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/logic/firebase/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(125.0),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(
                MediaQuery.of(context).size.width,
                100.0,
              ),
            ),
          ),
        ),
      ),
      body: Column(
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
      ),
    );
  }
}
