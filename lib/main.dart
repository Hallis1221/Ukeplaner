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
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';

FirebaseAnalytics analytics;
bool localDevMode = true;
String messageType = "snackbar";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirebaseApp(
      routes: {
        '/': (context) {
          return VerifyApp(route: '/login');
        },
        '/login': (context) {
          return SharedScaffold(
            body: MessageHandler(child: LoginScreen()),
          );
        }
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: () {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Test",
              ),
            ),
          );
        },
        child: Text(
          "Login",
        ),
      ),
    );
  }
}

class MessageHandler extends StatefulWidget {
  const MessageHandler({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static FirebaseMessaging fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {

        final snackbar = SnackBar(
          content: Text(
            message["notification"]["title"],
          ),
          action: SnackBarAction(
            label: "Sjekk ut!",
            onPressed: () {
              showDialog(
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
            },
          ),
        );d
        Scaffold.of(context).showSnackBar(snackbar);
      },
      onResume: (Map<String, dynamic> message) async {
      },
      onLaunch: (Map<String, dynamic> message) async {
        showDialog(
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}

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

class FirebaseApp extends StatelessWidget {
  const FirebaseApp({
    @required this.routes,
    Key key,
    this.initialRoute = "/",
  }) : super(key: key);

  final Map<String, Widget Function(BuildContext)> routes;
  final String initialRoute;

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
            Trace analyticsTrace =
                FirebasePerformance.instance.newTrace("firebase_startup_trace");
            analyticsTrace.start();
            analytics = FirebaseAnalytics();
            FlutterError.onError =
                FirebaseCrashlytics.instance.recordFlutterError;
            FirebaseCrashlytics.instance.checkForUnsentReports();
            analyticsTrace.stop();
          } catch (e) {
            throw FlutterError(
              "Failed to start firebase. Error: $e",
            );
          }

          var materialApp = MaterialApp(
            title: 'Ukeplaner app',
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              FirebaseAnalyticsObserver(
                analytics: analytics,
              ),
            ],
            initialRoute: initialRoute,
            routes: routes,
          );
          return materialApp;
        }
        return LoadingFlipping.circle(
          duration: Duration(milliseconds: 750),
        );
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

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      body: Center(
        child: Text(
          "Something went wrong...",
        ),
      ),
    );
  }
}
