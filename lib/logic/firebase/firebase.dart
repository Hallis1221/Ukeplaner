import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/logic/firebase/auth_service.dart';
import 'package:ukeplaner/screens/temp/error.dart';
import '../../config/config.dart';

RemoteConfig remoteConfig;

class LocalFirebaseApp extends StatelessWidget {
  const LocalFirebaseApp({
    @required this.routes,
    @required this.theme,
    Key key,
    this.initialRoute = "/",
    this.welcomeScreenPageList,
  }) : super(key: key);

  final Map<String, Widget Function(BuildContext)> routes;
  final String initialRoute;
  final ThemeData theme;
  final List welcomeScreenPageList;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorPage();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Future<void> remote() async {
            remoteConfig = await RemoteConfig.instance;
            final defaults = <String, dynamic>{'hjem_tekst': 'default welcome'};
            await remoteConfig.setDefaults(defaults);
// !! TODO For utvikling den er micro sekunder, bør være en time eller lignende i produksjon
            await remoteConfig.fetch(
                expiration: const Duration(microseconds: 1));
            await remoteConfig.activateFetched();
          }

          remote();
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
              theme: theme,
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
