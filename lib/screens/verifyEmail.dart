/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/elements/bottomCircle.dart';
import 'package:ukeplaner/logic/firebase/auth_services.dart';
import 'package:ukeplaner/screens/verify.dart';
import 'login.dart';
import 'verify.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LogoAndText(
                    title: "Email verifikasjon",
                    text:
                        "Venligst bekreft email adressen din for å bruke $schoolName ukeplaner.",
                  ),
                  Column(
                    children: [
                      PurpleButton(
                        onPressed: () {
                          verifyEmail(context);
                        },
                        title: "Klikk for å få verifikasjons mail",
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        fontSize: 20,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      PurpleButton(
                        onPressed: () {
                          checkEmailVerification(context);
                        },
                        title:
                            "Sjekk for verifikasjon. (Dette vil automatisk logge deg inn og ut)",
                        width: MediaQuery.of(context).size.width / 1.6,
                        height: 50,
                        fontSize: 15,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      PurpleButton(
                        onPressed: () {
                          context.read<AuthenticationService>().signOut();
                        },
                        title: "Logg ut",
                        width: MediaQuery.of(context).size.width / 1.6,
                        height: 50,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            BottomCircle(),
          ],
        ),
      ),
    );
  }

  void verifyEmail(BuildContext context) {
    context.read<AuthenticationService>().verifyCurrentUser(context);
    analytics.logEvent(name: "bruker_mail_vertifisert");
  }

  void checkEmailVerification(BuildContext context) {
    context.read<AuthenticationService>().signOut();
    context
        .read<AuthenticationService>()
        .signIn(email: tempEmail, password: tempPassword);
    tempEmail = null;
    tempPassword = null;
  }
}
