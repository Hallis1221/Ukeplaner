Future<List<Test>> getTests() async {
  List<Test> tests = [];
  for (String code in config.cloudClassesCodes) {
    var currentTest;
    DocumentReference documentReference =
        config.db.collection("classes").doc(code);
    config.analytics.logEvent(name: "get_classes_$code");
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
