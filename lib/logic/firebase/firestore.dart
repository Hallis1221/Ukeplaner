import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<Map> getDocument(
  DocumentReference documentReference,
  Duration timeTrigger,
) async {
  dynamic cacheData = readCache(documentReference.path);
  if (cacheData == null) {
    print("got a document with the id: ${documentReference.path}");
    Map map = await documentReference.get().then((value) => value.data());
    writeCache(filename: documentReference.path, content: map);
    return map;
  } else {
    return cacheData;
  }
}

Future<void> writeCache({String filename, Map content}) async {
  final file = await _localFile(filename);
  Map<String, dynamic> _json = {};
  String _jsonString;
  Map<String, dynamic> _newJson;
  if (content == null) return null;
  content.forEach(
    (key, value) {
      if (value is Timestamp) {
        Timestamp timestamp = value;
        value = timestamp.millisecondsSinceEpoch;
        key = "TIMESTAMP_$key";
      }
      _newJson = {key: value};
      _json.addAll(_newJson);
    },
  );
  _jsonString = jsonEncode(_json);
  // Write the file.
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
        _json.forEach(
          (key, value) {
            if (key.startsWith("TIMESTAMP_")) {
              _json[key] = new Timestamp.fromMillisecondsSinceEpoch(value);
              key = key.replaceAll("TIMESTAMP_", "");
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
    return null;
  } catch (e) {
    // If encountering an error, return 0.
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
