import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/firebase/fcm.dart';

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

      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
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
            },
          );
          // A users role is not set by the user for security purposes
        },
      );
      getCurrentUser().then((user) => saveDeviceToken(
          user, FirebaseMessaging(), FirebaseFirestore.instance));
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
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
      Scaffold.of(context).showSnackBar(
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
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message,
          ),
        ),
      );
    }
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Sjekk eposten din, $email"),
      ),
    );
  }
}

class VerificationSerivice {
  Future<bool> checkCode(int input) async {
    /*
    FirebaseFunctions.instance
        .useFunctionsEmulator(origin: 'http://localhost:5001'); */

    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('checkcode');
    final results = await callable.call(<String, int>{"code": input});
    // planen var egt å bare hente alle kodene, men da ville appen vært enkel å bryte seg inn i
    return results.data;
  }
}
