import 'package:flutter/material.dart';
import 'package:ukeplaner/screens/temp/login.dart';

import 'logic/firebase.dart';
import 'logic/firebase/fcm.dart';
import 'logic/network.dart';
import 'widgets/scaffold.dart';

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
            route: '/login',
          );
        },
        '/login': (context) {
          return SharedScaffold(
            body: LocalMessageHandler(
              child: LoginScreen(),
            ),
          );
        }
      },
    );
  }
}
