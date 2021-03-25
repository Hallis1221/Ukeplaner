/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute or modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter/material.dart';
import 'package:ukeplaner/screens/profile.dart';
import 'package:ukeplaner/screens/register.dart';
import 'package:ukeplaner/screens/home.dart';
import 'package:ukeplaner/screens/login.dart';
import 'package:flutter/services.dart';
import 'package:ukeplaner/screens/testPlan.dart';
import 'package:ukeplaner/screens/verifyEmail.dart';
import 'package:ukeplaner/screens/dayPlan.dart';
import 'package:ukeplaner/screens/weekPlan.dart';
import 'config/config.dart';
import 'logic/finPage.dart';
import 'logic/firebase/authGuider.dart';
import 'logic/firebase/firebase.dart';
import 'logic/futureValidateBuilder.dart';
import 'logic/getClasses.dart';
import 'config/config.dart' as config;
import 'screens/verify.dart';
import 'screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting("nb_NO");
  remote(remoteConfig).then((value) {
    config.remoteConfig = value;
  });
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
        '/findpage': FindPage(),
        '/welcome': OnBoardingPage(),
        '/validate': AuthenticatonWrapper(
          loggedin: FutureValidateBuilder(),
          login: LoginScreen(),
        ),
        '/home': FutureBuilder(
          future: getClasses(),
          builder: (context, snapshot) {
            _getDocs();
            if (snapshot.connectionState == ConnectionState.done) {
              return HomeScreen(
                subjects: snapshot.data,
              );
            }
            return LoadingFlipping.circle();
          },
        ),
        '/profile': ProfilePage(),
        '/testPlan': Testplan(),
        '/weekPlan': FutureBuilder(
          future: getClasses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return WeekPlan(
                subjects: snapshot.data,
              );
            }
            return LoadingFlipping.circle();
          },
        ),
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

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
