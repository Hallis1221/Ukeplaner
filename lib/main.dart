import 'package:flutter/material.dart';
import 'package:ukeplaner/screens/register.dart';
import 'package:ukeplaner/screens/temp/home.dart';
import 'package:ukeplaner/screens/login.dart';
import 'package:ukeplaner/screens/temp/verifyEmail.dart';
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
            route: '/validate',
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
