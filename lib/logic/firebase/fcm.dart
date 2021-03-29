/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import '../../config/config.dart';

class LocalMessageHandler extends StatefulWidget {
  const LocalMessageHandler({
    Key key,
    @required this.onDone,
  }) : super(key: key);

  final String onDone;

  @override
  _LocalMessageHandlerState createState() => _LocalMessageHandlerState();
}

class _LocalMessageHandlerState extends State<LocalMessageHandler> {
  static FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    // hvis ios, be om tilatelse
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (message["notification"] != null) {
          analytics.logEvent(name: "varsel_mottatt_app");
          final snackbar = SnackBar(
            content: Text(
              message["notification"]["title"],
            ),
            action: SnackBarAction(
              label: "Sjekk ut!",
              onPressed: () {
                showNotificationDialog(message);
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        analytics.logEvent(name: "varsel_mottatt_resume");
        showNotificationDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        analytics.logEvent(name: "varsel_mottatt_launch");
        showNotificationDialog(message);
      },
    );
  }

  Future showNotificationDialog(Map<String, dynamic> message) {
    if (message["notification"] == null ||
        message["notification"]["title"] == null ||
        message["notification"]["body"] == null) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text("Du har en ny beskjed!"),
            subtitle: Text(
                "Du har fått en ny beskjed, vi ville elsket å vise den til deg, men dessvere var denne meldingen sent fra firebase console som ikke støtter det. Trykk på bjella for å se alle dine meldinger"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("ok"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    }
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message["notification"]["title"]),
          subtitle: Text(message["notification"]["body"]),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("ok"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        Future.delayed(
          const Duration(milliseconds: 250),
          () => Navigator.pushReplacementNamed(context, "/home"),
        );
        return LoadingFlipping.circle(
          duration: Duration(milliseconds: 750),
        );
      },
    );
  }
}

saveDeviceToken(User user, _fcm, _db) async {
  String uid = user.uid;
  String fcmToken = await _fcm.getToken();

  if (fcmToken != null) {
    DocumentReference tokenRef =
        _db.collection("users").doc(uid).collection("FCMTokens").doc(fcmToken);
    await tokenRef.set(
      {
        'token': fcmToken,
        "createdAt": FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      },
    );
  }
}
