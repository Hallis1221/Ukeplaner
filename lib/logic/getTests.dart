import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:ukeplaner/logic/test.dart';

Future<List<Test>> getTests() async {
  List<Test> tests = [];
  for (String code in cloudClassesCodes) {
    var currentTest;
    DocumentReference documentReference = db.collection("classes").doc(code);
    analytics.logEvent(name: "get_classes_$code");
    print("got_$code");
    await FirestoreCache.getDocument(documentReference).then((value) {
      currentTest = value.data()["tests"];
      for (var test in currentTest) {
        Timestamp timeStamp = test["date"];
        tests.add(new Test(
            date: timeStamp.toDate(),
            message: test["message"],
            title: test["title"]));
      }
    });
  }
  return tests;
}
