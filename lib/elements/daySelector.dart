import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:ukeplaner/config/config.dart';
import '../logic/tekst.dart';
import '../screens/home.dart';

class DaySelector extends StatelessWidget {
  const DaySelector({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: ScrollSnapList(
        itemSize: ((MediaQuery.of(context).size.width / 8) * 2) + 40,
        onItemFocus: (index) async {
          if (currentPageSelected == index) {
            return;
          }
          currentPageSelected = index;
          await new Future.delayed(const Duration(milliseconds: 500));
          onTap();
        },
        initialIndex: double.parse(currentPageSelected.toString()),
        itemCount: 14,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              currentPageSelected = index;
              onTap();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 8,
                ),
                Container(
                  child: Text(
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
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 8,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
