import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: () {
          SnackBar snackbar = SnackBar(
            content: Text(
              "Test",
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          /*   Scaffold.of(context).showSnackBar(
            snackbar,
          ); */
        },
        child: Text(
          "Login",
        ),
      ),
    );
  }
}
