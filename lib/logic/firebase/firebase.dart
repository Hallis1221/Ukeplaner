/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

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
import 'auth_services.dart';
import 'package:ukeplaner/screens/temp/error.dart';
import '../../config/config.dart';

RemoteConfig remoteConfig;

class LocalFirebaseApp extends StatelessWidget {
  const LocalFirebaseApp({
    @required this.routes,
    @required this.theme,
    Key key,
    this.initialRoute = "/",
  }) : super(key: key);

  final Map<String, Widget Function(BuildContext)> routes;
  final String initialRoute;
  final ThemeData theme;

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
            final defaults = <String, dynamic>{
              'hjem_tekst': 'default welcome',
              "skole_navn": "KG",
              "skole_nettside": "https://kg.vgs.no",
              "verifikasjon_tittel": "Verifikasjon",
              "verifikasjon_tekst":
                  "Tast Inn Den Fire Sifrete Koden Du Har Fått Av Læreren Din",
            };
            await remoteConfig.setDefaults(defaults);
// For utvikling den er micro sekunder, bør være en time eller lignende i produksjon
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
