import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/logic/firebase/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
