/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/screens/loadingScreen.dart';

import 'auth_services.dart';
import '../../logic/class.dart';
import '../../logic/classTimes.dart';
import '../../logic/firebase/firestore.dart';
import '../network.dart';
import '../../screens/temp/error.dart';
import '../../config/config.dart';

class LocalFirebaseApp extends StatelessWidget {
  const LocalFirebaseApp({
    @required this.routes,
    @required this.theme,
    Key key,
    this.initialRoute = "/",
  }) : super(key: key);

  final Map<String, Widget> routes;
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

          return FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              if (true) {
                return MultiProvider(
                  providers: [
                    Provider<AuthenticationService>(
                      create: (_) => AuthenticationService(
                        FirebaseAuth.instance,
                      ),
                    ),
                    StreamProvider(
                      create: (context) => context
                          .read<AuthenticationService>()
                          .authStateChanges,
                    ),
                  ],
                  child: MaterialApp(
                    title: 'Ukeplaner app',
                    theme: theme,
                    debugShowCheckedModeBanner: false,
                    onGenerateRoute: (settings) {
                      var page = routes[settings.name];
                      switch (settings.name) {
                        case '/':
                          return PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    page,
                          );

                          break;
                        case '/testPlan':
                          print("route name: ${settings.name}");
                          return PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    page,
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(5.0, 5.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          );
                          break;
                        case '/weekPlan':
                          print("route name: ${settings.name}");
                          return PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    page,
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(-5.0, 5.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          );
                          break;
                        default:
                          print("route name: ${settings.name}");
                          return PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    page,
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(0.0, -1.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          );
                      }
                    },
                    navigatorObservers: [
                      FirebaseAnalyticsObserver(
                        analytics: analytics,
                      ),
                    ],
                    routes: {
                      '/': (context) {
                        return VerifyApp(
                          route: '/findpage',
                        );
                      }
                    },
                    initialRoute: initialRoute,
                  ),
                );
              }
              /*   return LoadingFlipping.circle(
                  duration: Duration(milliseconds: 750),
                );*/
            },
          );
        }
        return LoadingAnimation();
      },
    );
  }
}

Future<RemoteConfig> remote() async {
  var remoteConfigInstance = await RemoteConfig.instance;
  final defaults = fcmDefaults;
  await remoteConfigInstance.setDefaults(defaults);
// For utvikling den er micro sekunder, bør være en time eller lignende i produksjon
  try {
    await remoteConfigInstance.fetch(expiration: const Duration(hours: 1));
  } catch (e) {}

  await remoteConfigInstance.activateFetched();
  return remoteConfigInstance;
}

List<String> doneIds = [];
Future<void> getClassesFromFirebase(BuildContext context) async {
  for (String classId in cloudClassesCodes) {
    print("doneId: $classId");

    if (fetchedClasses || doneIds.contains(classId)) {
      return;
    }

    DocumentReference documentReference = db.collection("classes").doc(classId);
    /*   await context
        .read<AuthenticationService>()
        .getCurrentUser()
        .then((User value) => print("uid: ${value.uid}"));*/
    await getDocument(
            documentReference: documentReference,
            timeTrigger: Duration(days: 2))
        .then((value) async {
      Map<String, dynamic> data = value;

      List<ClassTime> times = [];
      for (var time in data["tider"]) {
        times.add(
          new ClassTime(
            aWeeks: time["aWeeks"],
            bWeeks: time["bWeeks"],
            dayIndex: time["dayIndex"],
            startTime: double.parse(time["startTime"].toString()),
            endTime: double.parse(time["endTime"].toString()),
          ),
        );
      }
      ClassModel newClass = new ClassModel(
          classFirestoreID: classId,
          className: data["name"],
          rom: data["rom"],
          teacher: data["teacher"],
          times: times);
      if (classes.contains(newClass) == false) {
        classes.add(newClass);
      }
    });

    doneIds.add(classId);
  }
  fetchedClasses = true;

  return;
}
