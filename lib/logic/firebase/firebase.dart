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
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/logic/class.dart';
import 'package:ukeplaner/logic/classTimes.dart';
import 'package:ukeplaner/screens/dayPlan.dart';
import '../network.dart';
import 'auth_services.dart';
import 'package:ukeplaner/screens/temp/error.dart';
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

                        if (settings.name == "/") {
                          print(true);
                        } else {
                          print(settings.name);
                        }
                        return PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) => page,
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(1.0, 0.0);
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
                      },
                      navigatorObservers: [
                        FirebaseAnalyticsObserver(
                          analytics: analytics,
                        ),
                      ],
                      routes: {
                        '/': (context) {
                          getClassesFromFirebase(context);
                          return VerifyApp(
                            route: '/findpage',
                          );
                        }
                      },
                      initialRoute: initialRoute,
                    ),
                  );
                }
                return LoadingFlipping.circle(
                  duration: Duration(milliseconds: 750),
                );
              });
        }
        return LoadingFlipping.circle(
          duration: Duration(milliseconds: 10000),
        );
      },
    );
  }
}

Future<RemoteConfig> remote(RemoteConfig remoteConfig) async {
  var remoteConfigInstance = await RemoteConfig.instance;
  final defaults = fcmDefaults;
  await remoteConfigInstance.setDefaults(defaults);
// For utvikling den er micro sekunder, bør være en time eller lignende i produksjon
  await remoteConfigInstance.fetch(expiration: const Duration(microseconds: 1));
  await remoteConfigInstance.activateFetched();
  return remoteConfigInstance;
}

List<String> doneIds = [];
Future<void> getClassesFromFirebase(BuildContext context) async {
  //TODO
  /*User user;
  await context.read<AuthenticationService>().getCurrentUser().then((value) {
    user = value;
    DocumentReference documentReference = db.collection("users").doc(user.uid);
    documentReference.get().then((value) {
      print(1);
      cloudClassesCodes = value.data()["classes"];
    });
  });*/

  for (String classId in cloudClassesCodes) {
    print("doneId: $classId");
    if (fetchedClasses || doneIds.contains(classId)) {
      return;
    }

    DocumentReference documentReference = db.collection("classes").doc(classId);

    await documentReference.get().then((value) async {
      Map<String, dynamic> data = value.data();

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
        print(1);
        classes.add(newClass);
      }
    });

    doneIds.add(classId);
  }
  fetchedClasses = true;
  return;
}
