/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/logic/firebase/firestore.dart';
import 'package:ukeplaner/screens/temp/error.dart';
import 'package:ukeplaner/screens/verifyEmail.dart';

class AuthenticatonWrapper extends StatelessWidget {
  const AuthenticatonWrapper({
    Key key,
    @required this.loggedin,
    @required this.login,
  }) : super(key: key);
  final Widget loggedin;
  final Widget login;

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      try {
        if (!firebaseUser.emailVerified) {
          return VerifyEmailPage();
        }
        DocumentReference _dcr = db.collection("users").doc(firebaseUser.uid);
        getDocument(_dcr, Duration()).then((value) {
          firstName = value["firstname"];
          lastName = value["lastname"];
        });
        _dcr = _dcr.collection("sensetive").doc("nowrite");
        getDocument(_dcr, Duration()).then(
          (value) {
            if (value["role"] == "teacher") {
              isTeacher = true;
            }
          },
        );
        return loggedin;
      } catch (e) {
        return ErrorPage();
      }
    }
    return login;
  }
}
