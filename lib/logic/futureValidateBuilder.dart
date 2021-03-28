import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/logic/firebase/firestore.dart';
import 'firebase/auth_services.dart';
import 'firebase/fcm.dart';

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
        return getDocument(_dcRef, Duration());
      }()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          DocumentSnapshot data = snapshot.data;

          cloudClassesCodes = data.get("classes");

          return LocalMessageHandler(onDone: '/home');
        }
        return LoadingFlipping.circle();
      },
    );
  }
}
