/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukeplaner/screens/loadingScreen.dart';

import '../config/config.dart';

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
  void initState() {
    Intl.defaultLocale = 'nb_NO';
    if (localDevMode) {
      String host = Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080';
      FirebaseFirestore.instance.settings = Settings(
        host: host,
        sslEnabled: false,
        persistenceEnabled: false,
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Center(child: LoadingAnimation()),
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
