import 'package:flutter/material.dart';

class WeekPlan extends StatelessWidget {
  const WeekPlan({Key key, @required this.dateToShow, @required this.subjects})
      : super(key: key);

  final DateTime dateToShow;
  final List<Map<String, dynamic>> subjects;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("//TODO"),
    );
  }
}
