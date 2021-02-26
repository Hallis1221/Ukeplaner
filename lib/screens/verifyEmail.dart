import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/logic/firebase/authGuider.dart';
import 'package:ukeplaner/logic/firebase/auth_services.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({Key key}) : super(key: key);

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
                analytics.logEvent(name: "bruker_mail_vertifisert");
              },
              child: Text(
                "Please click to get a verification email",
              ),
            ),
            FlatButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
                context
                    .read<AuthenticationService>()
                    .signIn(email: tempEmail, password: tempPassword);
                tempEmail = null;
                tempPassword = null;
              },
              child: Text(
                "refresh",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
