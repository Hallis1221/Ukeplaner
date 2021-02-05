import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics analytics;

void main() {
  analytics = FirebaseAnalytics();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      routes: {
        '/': (context) => Text("Inital route"),
      },
    );
  }
}

class SharedScaffold extends StatelessWidget {
  final Widget body;

  SharedScaffold({@required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this.body,
    );
  }
}
