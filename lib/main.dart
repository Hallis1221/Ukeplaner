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
import 'package:ukeplaner/screens/testPlan.dart';
import 'package:ukeplaner/screens/verifyEmail.dart';
import 'package:ukeplaner/screens/dayPlan.dart';
import 'package:ukeplaner/screens/weekPlan.dart';
import 'config/config.dart';
import 'logic/firebase/authGuider.dart';
import 'logic/firebase/firebase.dart';
import 'logic/firebase/fcm.dart';
import 'logic/network.dart';
import 'config/config.dart' as config;
import 'screens/verify.dart';
import 'screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting("nb_NO");

  await remote(remoteConfig).then((value) {
    config.remoteConfig = value;
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return LocalFirebaseApp(
      initialRoute: '/',
      theme: config.theme,
      routes: {
        '/findpage': FindPage(),
        '/welcome': OnBoardingPage(),
        '/validate': AuthenticatonWrapper(
          loggedin: FutureValidateBuilder(),
          login: LoginScreen(),
        ),
        '/home': HomeScreen(),
        '/testPlan': Testplan(),
        '/weekPlan': WeekPlan(),
        '/dayplan': FutureBuilder(
          future: getClasses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return DayPlan(subjects: snapshot.data);
            }
            return LoadingFlipping.circle();
          },
        ),
        '/verify': VerifyPage(),
        '/verify/email': VerifyEmailPage(),
        '/register': RegisterPage(),
      },
    );
  }
}

class FindPage extends StatelessWidget {
  const FindPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    startTime(context);
    return Loading();
  }
}

class FutureValidateBuilder extends StatelessWidget {
  const FutureValidateBuilder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: (() async {
        String uid = "";

        await context
            .read<AuthenticationService>()
            .getCurrentUser()
            .then((value) {
          try {
            uid = value.uid;
          } catch (e) {
            return;
          }
        });

        DocumentReference _dcRef = config.db.collection("users").doc(uid);
        return _dcRef.get();
      }()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          DocumentSnapshot data = snapshot.data;
          config.cloudClassesCodes = data.get("classes");

          return LocalMessageHandler(onDone: '/home');
        }
        return LoadingFlipping.circle();
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

Future<List<ClassModel>> getClasses() async {
  return config.classes;
}
