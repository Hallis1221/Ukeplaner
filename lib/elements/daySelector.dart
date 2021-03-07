import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
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
      child: ScrollSnapList(
        itemSize: ((MediaQuery.of(context).size.width / 8) * 2) + 40,
        onItemFocus: null,
        initialIndex: double.parse(currentPageSelected.toString()),
        itemCount: 14,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
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
