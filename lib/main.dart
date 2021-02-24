import 'package:fancy_on_boarding/fancy_on_boarding.dart';
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
          return Scaffold(
            body: FancyOnBoarding(
              doneButtonText: "Done",
              skipButtonText: "Skip",
              pageList: [],
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
