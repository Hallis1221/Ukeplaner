import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/config.dart';
import '../logic/firebase/firestore.dart';
import '../logic/test.dart';

Future<List<Test>> getTests() async {
  List<Test> tests = await _getList();
  print("4");
  return tests;
}

Future<List<Test>> _getList() async {
  List<Test> tests = [];
  for (String code in cloudClassesCodes) {
    print(2);
    DocumentReference documentReference = db.collection("classes").doc(code);

    var value = await getDocument(
        documentReference: documentReference,
        timeTrigger: new Duration(hours: 1));

    print("VERID ER $value");
    List currentTest = value["tests"];
    print("tests;  $currentTest");
    for (var test in currentTest) {
      print("test; $test");
      int timeStamp = test["TIMESTAMP_date"];
      tests.add(new Test(
          date: Timestamp.fromMicrosecondsSinceEpoch(timeStamp).toDate(),
          message: test["message"],
          title: test["title"]));
      print("tests list: $tests");
    }
    print(3);
    print("KOM HIT");
  }
  print("KOMER HIT");
  return tests;
}
