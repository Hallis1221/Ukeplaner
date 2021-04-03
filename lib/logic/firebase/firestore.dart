import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import '../../screens/home.dart';

Future<Map> getDocument({
  DocumentReference documentReference,
  Duration timeTrigger,
}) async {
  dynamic cacheData = await readCache(documentReference.path);
  DateTime updatedAt;
  bool outDated = true;
  var error;

  // prøv å bruke cache til å finne ut når dokumentet ble sist oppdatert. Hvis den failer (feks fordi cacheData er null)
  try {
    updatedAt = cacheData["updatedAt"];
    outDated = now.difference(updatedAt) >= timeTrigger;
    print(
        "differnece: ${now.difference(updatedAt)} and timeTrigger is at $timeTrigger. Now is $now and updatedAt is $updatedAt");
  } catch (e) {
    print("error: $e");
    updatedAt = null;
    outDated = true;
    error = e;
  }

  if (cacheData == null || outDated || cacheData == [] && true) {
    try {
      print(
          """got:  ${documentReference.path} beacuse cache was null?   ${cacheData == null} it was outdated $outDated. was there an error? $error
         """);
    } catch (e) {
      print(e);
    }

    print("DID NOT USE CACHE");
    Map map = await documentReference.get().then((value) => value.data());
    print(
        "Trying to write to $documentReference with the following content: $map");
    await writeCache(filename: documentReference.path, content: map);
    return map;
  } else {
    print("USED CACHE");
    return cacheData;
  }
}

Future<void> writeCache({String filename, Map content}) async {
  final file = await _localFile(filename);
  Map<String, dynamic> _json = {};
  String _jsonString;
  Map<String, dynamic> _newJson;
  if (content == null) {
    Map nullMap = {
      "value": content,
      'updatedAt': now.toString(),
    };
    String nullValue = jsonEncode(nullMap);
    file.writeAsString(nullValue);
    return null;
  }
  content.forEach(
    (key, value) {
      if (value is Timestamp) {
        Timestamp timestamp = value;
        value = timestamp.millisecondsSinceEpoch;
        key = "TIMESTAMP_$key";
      }
      if (key == "tests" && value is List) {
        List newList = [];

        for (Map element in value) {
          List elementsToRemove = [];
          Map elementsToAdd = {};
          element.forEach((key, value) {
            if (value is Timestamp) {
              elementsToRemove.add(key);
              elementsToAdd["TIMESTAMP_$key"] = value.millisecondsSinceEpoch;
            }
          });

          element.removeWhere((key, value) => elementsToRemove.contains(key));
          elementsToAdd.forEach((key, value) {
            element[key] = value;
          });
          newList.add(element);
        }
        value = newList;
        print("tests: $value");
      }
      _newJson = {key: value};
      _json.addAll(_newJson);
    },
  );
  _json.addAll(
    {'updatedAt': now.toString()},
  );
  print(_json);
  _jsonString = jsonEncode(_json);
  // Write the file.
  print(
      "Writing the jsonstring: $_jsonString to $file. The raw json was: $json");
  return file.writeAsString(_jsonString);
}

Future<Map> readCache(String filename) async {
  Map<String, dynamic> _json = {};
  String _jsonString;
  try {
    final file = await _localFile(filename);

    // Read the file.

    // 0. Check whether the _file exists
    bool _fileExists = await file.exists();
    print('0. File exists? $_fileExists');

    // If the _file exists->read it: update initialized _json by what's in the _file
    if (_fileExists) {
      try {
        //1. Read _jsonString<String> from the _file.
        _jsonString = await file.readAsString();

        print('1.(_readJson) _jsonString: $_jsonString');

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>
        _json = jsonDecode(_jsonString);
        if (_json == null) {
          print(
              "JSON IS NULL and json string is: $_jsonString. The file path was: $file");
        }
        _json.forEach(
          (key, value) {
            if (key.startsWith("TIMESTAMP_")) {
              _json[key] = new Timestamp.fromMillisecondsSinceEpoch(value);
              key = key.replaceAll("TIMESTAMP_", "");
            }
            if (key == "updatedAt") {
              _json[key] = DateTime.parse(value);
            }
            if (value is List) {
              List newList = [];
              value.forEach(
                (element) {
                  if (element is Map && element.isNotEmpty) {
                    List keysToRemove = [];
                    Map stuffToAdd = {};
                    element.forEach((deepKey, deepValue) {
                      if (deepKey.startsWith("TIMESTAMP_")) {
                        keysToRemove.add(deepKey);
                        stuffToAdd.addAll(
                          {
                            deepKey.toString().replaceAll("TIMESTAMP_", ""):
                                new Timestamp.fromMillisecondsSinceEpoch(
                                    deepValue),
                          },
                        );
                      } else {
                        print("key: $deepKey");
                      }
                    });
                    element.removeWhere(
                        (key, value) => keysToRemove.contains(key));
                    if (stuffToAdd.isNotEmpty) {
                      stuffToAdd.forEach(
                        (_key, _value) {
                          element[_key] = _value;
                        },
                      );
                    }
                    newList.add(element);
                  }
                },
              );
              if (newList.isEmpty) {
                newList = value;
              }
              print("newvalues: $newList, length: ${value.length}");
              _json[key] = newList;
            }
          },
        );
        print('2.(_readJson) _json: $_json \n - \n');
        return _json;
      } catch (e) {
        // Print exception errors
        print('Tried reading _file error: $e');
        return null;
        // If encountering an error, return null
      }
    }
    print("ERROR LEVEL 1");
    return null;
  } catch (e) {
    // If encountering an error, return 0.
    print("ERROR LEVEL 0");
    return null;
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localFile(String name) async {
  final path = await _localPath;
  final fileName = name.replaceAll("/", ".");
  return File('$path/$fileName.up');
}
