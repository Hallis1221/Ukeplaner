import 'package:firebase_messaging/firebase_messaging.dart';

import '../config/config.dart';
import '../logic/class.dart';

List subscribed = [];

Future<List<ClassModel>> getClasses() async {
  if (!gottenTopics) {
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    for (ClassModel classe in classes) {
      if (!subscribed.contains(classe.classFirestoreID)) {
        print("subscribed to: ${classe.classFirestoreID}");
        firebaseMessaging.subscribeToTopic(classe.classFirestoreID);
        subscribed.add(classe.classFirestoreID);
      }
    }
  }
  print("classes: $classes");
  return classes;
}
