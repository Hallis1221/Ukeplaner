import 'package:flutter/material.dart';
import 'package:ukeplaner/screens/login.dart';

class WeekPlan extends StatelessWidget {
  const WeekPlan({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(115),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [TopDecorationHalfCircle()],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            color: Colors.green,
            child: Row(children: [
              Column(
                children: [
                  Container(
                    child: Text('max kan ikke matte'),
                  ),
                  WeekPlanBox()
                ],
              ),
            ]),
          ))
        ],
      ),
    );
  }
}

class WeekPlanBox extends StatelessWidget {
  const WeekPlanBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 128,
      decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
