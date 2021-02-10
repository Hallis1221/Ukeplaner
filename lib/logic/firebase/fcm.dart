import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LocalMessageHandler extends StatefulWidget {
  const LocalMessageHandler({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  _LocalMessageHandlerState createState() => _LocalMessageHandlerState();
}

class _LocalMessageHandlerState extends State<LocalMessageHandler> {
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _fcm.requestNotificationPermissions(IosNotificationSettings());
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("message");
        if (message["notification"] != null) {
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
        print("resume");
        showNotificationDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("launched");
        showNotificationDialog(message);
      },
    );
  }

  Future showNotificationDialog(Map<String, dynamic> message) {
    if (message["data"]["google.message_id"] ==
        '0:1612718485437491%629c5fec629c5fec') {
      return null;
    }
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
            FlatButton(
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
          FlatButton(
            child: Text("ok"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
