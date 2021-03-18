import 'package:flutter/material.dart';

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

        DocumentReference _dcRef = config.db.collection("users").doc(uid);
        return FirestoreCache.getDocument(_dcRef);
      }()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          DocumentSnapshot data = snapshot.data;
          analytics.logEvent(name: "get_classes");
          print("got_classes");
          config.cloudClassesCodes = data.get("classes");

          return LocalMessageHandler(onDone: '/home');
        }
        return LoadingFlipping.circle();
      },
    );
  }
}
