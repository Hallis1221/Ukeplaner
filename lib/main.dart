import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:loading_animations/loading_animations.dart';

FirebaseAnalytics analytics;
bool localDevMode = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: analytics,
        ),
      ],
      initialRoute: "/connect",
      routes: {
        '/connect': (context) {
          return SharedScaffold(body: Text("2312"));
        },
      },
    );
  }
}

class FirebaseConnect extends StatelessWidget {
  const FirebaseConnect({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorPage();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          try {
            Trace fbsTrace =
                FirebasePerformance.instance.newTrace("firebase_startup_trace");
            fbsTrace.start();
            analytics = FirebaseAnalytics();
            FlutterError.onError =
                FirebaseCrashlytics.instance.recordFlutterError;
            FirebaseCrashlytics.instance.checkForUnsentReports();
            fbsTrace.stop();
            checkConnection().then((connected) {
              if (connected) {
                AlertDialog(content: Text("yo"));
              } else {}
            });
          } catch (e) {
            throw FlutterError(
              "Failed to start firebase. Error: $e",
            );
          }
        }
        return LoadingFlipping.circle();
      },
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

class SharedScaffold extends StatefulWidget {
  final Widget body;

  SharedScaffold({@required this.body});

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
        return Text("Something failed...");
      }
    }()));
  }
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(body: Text("Something went wrong..."));
  }
}

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    // TODO figure out how FCM works and implement it here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
