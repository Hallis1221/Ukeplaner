/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../config/config.dart';
import '../../logic/firebase/fcm.dart';
import 'package:provider/provider.dart';

String tempPassword;
String tempEmail;

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  AuthenticationService(
    this._firebaseAuth,
  );

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          return;
        }
        saveDeviceToken(user, FirebaseMessaging(), _db);
      });
      tempPassword = password;
      tempEmail = email;
      analytics.logLogin();
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<Map> signUp(
      {@required String email,
      @required String password,
      @required String firstname,
      @required String lastname,
      int code}) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (UserCredential user) {
          _db.collection("users").doc(user.user.uid.toString().trim()).set(
            {
              'createdAt': FieldValue.serverTimestamp(),
              'createdPlatform': Platform.operatingSystem,
              'email': user.user.email,
              'firstname': firstname,
              'lastname': lastname,
              'registrationCode': code,
            },
          );
          // A users role is not set by the user for security purposes
        },
      );
      analytics.logSignUp(signUpMethod: "viaCode");
      getCurrentUser().then((user) => saveDeviceToken(
          user, FirebaseMessaging(), FirebaseFirestore.instance));
      return {"done": true, "message": "Bruker lagd"};
    } on FirebaseAuthException catch (e) {
      return {"done": false, "message": e.toString()};
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> verifyCurrentUser(context) async {
    try {
      await _firebaseAuth.currentUser.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message,
          ),
        ),
      );
    }
  }

  Future<void> resetCurrentUserPassword(context, {email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message,
          ),
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Sjekk eposten din, $email"),
      ),
    );
  }
}

class VerificationSerivice {
  Future<bool> checkCode(int input, {bool log = false}) async {
    /*
    FirebaseFunctions.instance
        .useFunctionsEmulator(origin: 'http://localhost:5001');
  */
    print("entered checkcode");
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('checkcode');
    //!! husk at det er et map
    print("entered results");
    // å bruke et map for argumenterer funker best når ting går mellom ulike språk
    final results = await callable.call({"code": input, "useLog": log});
    // planen var egt å bare hente alle kodene, men da ville appen vært enkel å bryte seg inn i
    print("code result: ${results.data}");
    return results.data;
  }

  Future registerUser({
    @required int code,
    @required String email,
    @required String password,
    @required String firstname,
    @required String lastname,
    @required BuildContext context,
    bool log = false,
  }) async {
    if (code == null ||
        email.isEmpty ||
        email == null ||
        password.isEmpty ||
        password == null ||
        firstname.isEmpty ||
        firstname == null ||
        lastname.isEmpty ||
        lastname == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Minst et felt er tomt"),
        ),
      );

      return false;
    }
    if (!validPassword(password, context)) {
      return false;
    }

    await VerificationSerivice().checkCode(code, log: true).then(
      (validCode) async {
        if (validCode) {
          try {
            await context
                .read<AuthenticationService>()
                .signUp(
                  firstname: firstname,
                  lastname: lastname,
                  email: email,
                  password: password,
                  code: code,
                )
                .then((value) async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value["message"].toString()),
                ),
              );
              if (value["done"]) {
                if (log) {
                  await VerificationSerivice()
                      .checkCode(code, log: log)
                      .then((validCodeI2) {
                    validCode = validCodeI2;
                  });
                }
                if (validCode) {
                  await context
                      .read<AuthenticationService>()
                      .signIn(
                        email: email,
                        password: password,
                      )
                      .then(
                        (value) => Navigator.pushReplacementNamed(
                            context, "/validate"),
                      );
                }
              }
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Koden er ugyldig. Den kan ha utløpt"),
            ),
          );
        }
      },
    );
  }

  bool validPassword(String password, context) {
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passordet må ha minst åtte bokstaver"),
        ),
      );
      return false;
    }
    bool oneUpper = false;
    bool oneLower = false;
    bool oneNumber = false;
    for (var i = 0; i < password.length; i++) {
      try {
        int.parse(password[i]);
        oneNumber = true;
        continue;
      } catch (e) {}
      if (password[i].toUpperCase() == password[i]) {
        oneUpper = true;
        continue;
      }
      if (password[i].toLowerCase() == password[i]) {
        oneLower = true;
        continue;
      }
    }
    if (!oneNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Du må ha minst et tall i passordet ditt."),
        ),
      );
    }
    if (!oneLower) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Du må ha minst en liten bokstav i passordet ditt."),
        ),
      );
    }
    if (!oneUpper) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Du må ha minst en stor bokstav i passordet ditt."),
        ),
      );
    }
    return true;
  }
}
