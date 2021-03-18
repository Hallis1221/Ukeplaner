import 'dart:async';

import 'package:flutter/material.dart';
import 'package:native_shared_preferences/native_shared_preferences.dart';
import 'package:ukeplaner/config/config.dart';

startTime(context) async {
  NativeSharedPreferences prefs = await NativeSharedPreferences.getInstance();
  bool firstTime = prefs.getBool('first_time');

  var _duration = new Duration(seconds: 0);

  if (firstTime != null &&
      !firstTime &&
      !remoteConfig.getBool('alltid_vis_intro')) {
    // Not first time
    return new Timer(_duration,
        () => Navigator.of(context).pushReplacementNamed('/validate'));
  } else {
    // First time
    prefs.setBool('first_time', false);
    return new Timer(_duration,
        () => Navigator.of(context).pushReplacementNamed('/welcome'));
  }
}
