import 'dart:async';

import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:native_shared_preferences/native_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ukeplaner/screens/register.dart';
import 'package:ukeplaner/screens/temp/home.dart';
import 'package:ukeplaner/screens/login.dart';
import 'package:flutter/services.dart';
import 'logic/firebase/authGuider.dart';
import 'logic/firebase/firebase.dart';
import 'logic/firebase/fcm.dart';
import 'logic/network.dart';
import 'config/config.dart' as config;
import 'screens/verify.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          return Text("data");
        },
        '/welcome': (context) {
          return Scaffold(
            body: FancyOnBoarding(
              doneButtonText: "Done",
              skipButtonText: "Skip",
              pageList: [
                PageModel(
                  color: const Color(0xFF678FB4),
                  heroImagePath: 'assets/png/hotels.png',
                  title: Text('Hotels',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 34.0,
                      )),
                  body: Text(
                    'All hotels and hostels are sorted by hospitality rating',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                )
              ],
              onDoneButtonPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/validate'),
              onSkipButtonPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/validate'),
            ),
          );
        },
        '/validate': (context) {
          return AuthenticatonWrapper(
            loggedin: LocalMessageHandler(child: HomeScreen()),
            login: LoginScreen(),
          );
        },
        '/verify': (context) {
          return VerifyPage();
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

  if (firstTime != null && !firstTime) {
    // Not first time
    prefs.setBool('first_time', true);
    return new Timer(_duration,
        () => Navigator.of(context).pushReplacementNamed('/validate'));
  } else {
    // First time
    prefs.setBool('first_time', true);
    return new Timer(_duration,
        () => Navigator.of(context).pushReplacementNamed('/welcome'));
  }
}
