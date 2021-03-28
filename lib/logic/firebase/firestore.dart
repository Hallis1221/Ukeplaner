import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<DocumentSnapshot> getDocument(
  DocumentReference documentReference,
  Duration timeTrigger,
) async {
  print("got a document with the id: ${documentReference.path}");
  return documentReference.get();
}

Future<File> writeCache(String filename, dynamic content) async {
  final file = await _localFile(filename);

  // Write the file.
  return file.writeAsString('$content');
}

Future<dynamic> readCounter(String filename) async {
  try {
    final file = await _localFile(filename);

    // Read the file.
    dynamic contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0.
    return 0;
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localFile(String name) async {
  final path = await _localPath;
  return File('$path/$name.up');
}
