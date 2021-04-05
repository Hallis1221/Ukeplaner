/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute or modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'dart:async';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/oss_license.dart';
import 'package:ukeplaner/screens/settings.dart';
import 'package:ukeplaner/screens/skoleFactsPage.dart';
import './screens/profile.dart';
import './screens/register.dart';
import './screens/home.dart';
import './screens/login.dart';
import 'package:flutter/services.dart';
import './screens/testPlan.dart';
import './screens/verifyEmail.dart';
import './screens/dayPlan.dart';
import './screens/weekPlan.dart';
import 'config/config.dart';
import 'logic/finPage.dart';
import 'logic/firebase/authGuider.dart';
import 'logic/firebase/firebase.dart';
import 'logic/futureValidateBuilder.dart';
import 'logic/getClasses.dart';
import 'config/config.dart' as config;
import 'screens/loadingScreen.dart';
import 'screens/verify.dart';
import 'screens/welcome_screen.dart';
import 'package:native_shared_preferences/native_shared_preferences.dart';

NativeSharedPreferences prefs;
_MyAppState parent;
Future<void> main() async {
  initApp();
  prefs = await NativeSharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    parent = this;
    _portraitModeOnly();
    return LocalFirebaseApp(
      initialRoute: '/',
      theme: (() {
        print('preset: ${prefs.getString("color_preset")}');
        String colorPreset = prefs.getString("color_preset");
        if (colorPreset == "maaz") {
          return config.maazTheme;
        } else if (colorPreset == "halvor") {
          return config.halvorTheme;
        }
      }()),
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
            if (snapshot.connectionState == ConnectionState.done) {
              return HomeScreen(
                subjects: snapshot.data,
              );
            }
            return LoadingPage();
          },
        ),
        '/profile': ProfilePage(),
        '/settings': SettingsMenu(),
        '/skoleFacts': SkoleFacts(),
        '/testPlan': Testplan(),
        '/licenses': OssLicensesPage(),
        '/weekPlan': FutureBuilder(
          future: getClasses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return WeekPlan(
                subjects: snapshot.data,
              );
            }
            return LoadingPage();
          },
        ),
        '/dayplan': FutureBuilder(
          future: getClasses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return DayPlan(subjects: snapshot.data);
            }
            return LoadingPage();
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

void initApp() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting("nb_NO");

  remote(remoteConfig).then((value) {
    config.remoteConfig = value;
  });
}
