import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class SharedScaffold extends StatefulWidget {
  final Widget body;

  SharedScaffold({
    @required this.body,
  });

  @override
  _SharedScaffoldState createState() => _SharedScaffoldState();
}

class _SharedScaffoldState extends State<SharedScaffold> {
  @override
  void initState() {
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
      if (widget.body != null) {
        return widget.body;
      } else {
        return Center(
          child: Text(
            "Something failed...",
          ),
        );
      }
    }()));
  }
}
