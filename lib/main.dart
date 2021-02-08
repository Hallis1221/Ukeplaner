import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ukeplaner/screens/temp/home.dart';
import 'package:ukeplaner/screens/temp/login.dart';

import 'logic/firebase/authGuider.dart';
import 'logic/firebase/firebase.dart';
import 'logic/firebase/fcm.dart';
import 'logic/network.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocalFirebaseApp(
      routes: {
        '/': (context) {
          return VerifyApp(
            route: '/validate',
          );
        },
        '/validate': (context) {
          return Scaffold(
            body: AuthenticatonWrapper(
              loggedin: LocalMessageHandler(child: HomeScreen()),
              login: LoginScreen(),
            ),
          );
        },
      },
    );
  }
}
