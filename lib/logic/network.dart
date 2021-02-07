import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
import 'package:ukeplaner/widgets/scaffold.dart';

class VerifyApp extends StatefulWidget {
  const VerifyApp({
    @required this.route,
    Key key,
  }) : super(key: key);

  final String route;

  @override
  _VerifyAppState createState() => _VerifyAppState();
}

class _VerifyAppState extends State<VerifyApp> {
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        body: (() {
      void tryToConnect() {
        checkConnection().then(
          (connected) {
            if (connected) {
              Navigator.pushReplacementNamed(
                context,
                widget.route,
              );
            } else {
              tryToConnect();
            }
          },
        );
      }

      tryToConnect();
      return ConnectionAttemptionScreen(route: widget.route);
    }()));
  }
}

class ConnectionAttemptionScreen extends StatelessWidget {
  const ConnectionAttemptionScreen({
    @required this.route,
    Key key,
  }) : super(key: key);

  final String route;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          route,
        );
      },
      child: Stack(
        children: [
          // TODO implement solution to connect offline
          Container(
            color: Colors.lightBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AlertDialog(
                  backgroundColor: Colors.blueAccent,
                  title: Text(
                    "Prøver å koble til internett... Trykk hvor som helst på skjermen for å fortsette uten nett",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Loading(
                    indicator: BallBeatIndicator(),
                    size: 100.0,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> checkConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}
