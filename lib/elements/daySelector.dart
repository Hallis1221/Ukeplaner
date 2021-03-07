import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukeplaner/config/config.dart';
import '../logic/tekst.dart';
import '../screens/home.dart';

class DaySelector extends StatelessWidget {
  const DaySelector({
    Key key,
    @required this.scrollController,
    @required this.parent,
  }) : super(key: key);

  final ScrollController scrollController;
  final State parent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        itemCount: 31,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // ignore: invalid_use_of_protected_member
              parent.setState(() {
                currentPageSelected = index;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: (() {
                    if (index == 0) {
                      return MediaQuery.of(context).size.width / 2.5;
                    } else {
                      return MediaQuery.of(context).size.width / 4;
                    }
                  }()),
                ),
                Text(
                  DateFormat('EEEE')
                      .format(getDate(addDays: index)['dateTime'])
                      .capitalize()
                      .onlyThreeFirst(),
                  style: TextStyle(
                    fontSize: 24,
                    color: (() {
                      if (currentPageSelected == index) {
                        return Color.fromARGB(255, 113, 137, 255);
                      } else {
                        return Color.fromARGB(255, 126, 126, 126);
                      }
                    }()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
