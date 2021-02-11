import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/logic/firebase/authGuider.dart';
import 'package:ukeplaner/logic/firebase/auth_service.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () {
                context
                    .read<AuthenticationService>()
                    .verifyCurrentUser(context);
              },
              child: Text(
                "Please click to get a verification email",
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/validate");
              },
              child: Text(
                "Refresh",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
