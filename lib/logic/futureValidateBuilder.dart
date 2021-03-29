import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'firebase/auth_services.dart';
import 'firebase/fcm.dart';

import '../config/config.dart';
import '../logic/firebase/firestore.dart';

class FutureValidateBuilder extends StatelessWidget {
  const FutureValidateBuilder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: (() async {
        String uid = "";

        await context
            .read<AuthenticationService>()
            .getCurrentUser()
            .then((value) {
          try {
            uid = value.uid;
          } catch (e) {
            return;
          }
        });

        DocumentReference _dcRef = db.collection("users").doc(uid);
        return getDocument(
            documentReference: _dcRef, timeTrigger: new Duration(days: 1));
      }()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map data = snapshot.data;

          cloudClassesCodes = data["classes"];

          return LocalMessageHandler(onDone: '/home');
        }
        return LoadingFlipping.circle();
      },
    );
  }
}
