import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/logic/firebase/auth_service.dart';
import 'package:ukeplaner/screens/temp/error.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../config.dart';

class LocalFirebaseApp extends StatelessWidget {
  const LocalFirebaseApp({
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
            RemoteConfig remoteconfig = RemoteConfig.instance as RemoteConfig;
            remoteconfig.setDefaults(<String, dynamic>{
              //skriv nøkellen og verdiene som er defaults her
              "hjem_tekst": "norge"
            });
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

          return MultiProvider(
            providers: [
              Provider<AuthenticationService>(
                create: (_) => AuthenticationService(
                  FirebaseAuth.instance,
                ),
              ),
              StreamProvider(
                create: (context) =>
                    context.read<AuthenticationService>().authStateChanges,
              ),
            ],
            child: MaterialApp(
              title: 'Ukeplaner app',
              debugShowCheckedModeBanner: false,
              navigatorObservers: [
                FirebaseAnalyticsObserver(
                  analytics: analytics,
                ),
              ],
              initialRoute: initialRoute,
              routes: routes,
            ),
          );
        }
        return LoadingFlipping.circle(
          duration: Duration(milliseconds: 750),
        );
      },
    );
  }
}
