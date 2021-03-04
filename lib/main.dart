/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute or modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading/loading.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:native_shared_preferences/native_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/class.dart';
import 'package:ukeplaner/logic/classTimes.dart';
import 'package:ukeplaner/logic/firebase/auth_services.dart';
import 'package:ukeplaner/screens/register.dart';
import 'package:ukeplaner/screens/home.dart';
import 'package:ukeplaner/screens/login.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/screens/verifyEmail.dart';
import 'package:ukeplaner/screens/weekPlan.dart';
import 'logic/firebase/authGuider.dart';
import 'logic/firebase/firebase.dart';
import 'logic/firebase/fcm.dart';
import 'logic/network.dart';
import 'config/config.dart' as config;
import 'screens/verify.dart';
import 'screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting("nb_NO");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return LocalFirebaseApp(
      initialRoute: '/',
      theme: config.theme,
      routes: {
        '/': (context) {
          return VerifyApp(
            route: '/findpage',
          );
        },
        '/findpage': (context) {
          startTime(context);
          return Loading();
        },
        '/welcome': (context) {
          return OnBoardingPage();
        },
        '/validate': (context) {
          return AuthenticatonWrapper(
            loggedin: FutureBuilder(
              future: (() {
                String uid;
                context
                    .read<AuthenticationService>()
                    .getCurrentUser()
                    .then((value) => uid = value.uid);
                DocumentReference _dcRef =
                    config.db.collection("users").doc(uid);
                return _dcRef.get();
              }()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print(snapshot.data);
                  return LocalMessageHandler(onDone: '/home');
                }
                return LoadingFlipping.circle();
              },
            ),
            login: LoginScreen(),
          );
        },
        '/home': (context) {
          return HomeScreen();
        },
        '/weekplan': (
          context,
        ) {
          return WeekPlan(dateToShow: getDate(), subjects: config.classes);
        },
        '/verify': (context) {
          return VerifyPage();
        },
        '/verify/email': (context) {
          return VerifyEmailPage();
        },
        '/register': (context) {
          return RegisterPage();
        }
      },
    );
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

startTime(context) async {
  NativeSharedPreferences prefs = await NativeSharedPreferences.getInstance();
  bool firstTime = prefs.getBool('first_time');

  var _duration = new Duration(seconds: 0);

  if (firstTime != null &&
      !firstTime &&
      !remoteConfig.getBool('alltid_vis_intro')) {
    // Not first time
    return new Timer(_duration,
        () => Navigator.of(context).pushReplacementNamed('/validate'));
  } else {
    // First time
    prefs.setBool('first_time', false);
    return new Timer(_duration,
        () => Navigator.of(context).pushReplacementNamed('/welcome'));
  }
}
