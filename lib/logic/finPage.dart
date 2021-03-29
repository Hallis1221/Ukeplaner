import 'package:flutter/material.dart';
import 'package:loading/loading.dart';
import '../logic/startTime.dart';

class FindPage extends StatelessWidget {
  const FindPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    startTime(context);
    return Loading();
  }
}
