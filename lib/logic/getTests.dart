import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:ukeplaner/logic/firebase/firestore.dart';
import 'package:ukeplaner/logic/test.dart';

Future<List<Test>> getTests() async {
  List<Test> tests = [];
  for (String code in cloudClassesCodes) {
    var currentTest;
    DocumentReference documentReference = db.collection("classes").doc(code);

    await getDocument(
            documentReference: documentReference,
            timeTrigger: new Duration(hours: 1))
        .then((value) {
      currentTest = value["tests"];
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
