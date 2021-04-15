/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sliver_fab/sliver_fab.dart';
import '../config/config.dart';
import '../elements/TopDecorationHalfCircle.dart';
import '../elements/maindrawer.dart';
import '../icons/custom_icons.dart';
import '../logic/class.dart';
import '../logic/class.dart';
import '../logic/dates.dart';
import '../logic/dates.dart';
import '../logic/firebase/firestore.dart';
import '../logic/getLekserWidgets.dart';
import '../logic/class.dart';
import '../logic/classTimes.dart';
import '../logic/firebase/auth_services.dart';
import 'package:ukeplaner/main.dart';
import '../logic/firebase/firebase.dart';
import '../logic/getLekserWidgets.dart';
import '../screens/login.dart';
import '../logic/tekst.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:provider/provider.dart';
import '../elements/maindrawer.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/widgets.dart';
import 'loadingScreen.dart';
import 'login.dart';

List<Widget> _rowChildrenController = [];

DateTime now = DateTime.now();
List<DateTime> tider = [];
String chossenTid;
String chossenId;
TextEditingController lekseTitleController = TextEditingController();
TextEditingController lekseBeskController = TextEditingController();
Map doneDates = {};

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
    @required this.subjects,
  }) : super(key: key);
  final List<ClassModel> subjects;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("height: ${size.height}");
    print("width: ${size.width}");
    DateTime date = getDate()["dateTime"];
    String themePreset = prefs.getString("theme_preset");
    if (themePreset == "1") {
      return MaazScaffold(size: size, date: date, subjects: subjects);
    } else if (themePreset == "2") {
      return HalvorScaffold(size: size, date: date, subjects: subjects);
    } else {
      return MaazScaffold(size: size, date: date, subjects: subjects);
    }
  }
}

class HalvorScaffold extends StatelessWidget {
  const HalvorScaffold({
    Key key,
    @required this.size,
    @required this.date,
    @required this.subjects,
  }) : super(key: key);

  final Size size;
  final DateTime date;
  final List<ClassModel> subjects;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: MainDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 125,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("${firstName.capitalize()} ${lastName.capitalize()}"),
              centerTitle: true,
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverToBoxAdapter(
            child: HomeMeat(
              date: date,
              size: size,
              subjects: subjects,
            ),
          ),
        ],
      ),
    );
  }
}

class MaazScaffold extends StatelessWidget {
  const MaazScaffold({
    Key key,
    @required this.size,
    @required this.date,
    @required this.subjects,
  }) : super(key: key);

  final Size size;
  final DateTime date;
  final List<ClassModel> subjects;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height / 5),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            TopDecorationHalfCircle(
              title: "${firstName.capitalize()} ${lastName.capitalize()}",
            ),
            DrawerButton(),
          ],
        ),
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: ListView(
        children: [HomeMeat(date: date, size: size, subjects: subjects)],
      ),
    );
  }
}

class HomeMeat extends StatelessWidget {
  const HomeMeat({
    Key key,
    @required this.date,
    @required this.size,
    @required this.subjects,
  }) : super(key: key);

  final DateTime date;
  final Size size;
  final List<ClassModel> subjects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MinePlaner(date: date),
        Lekser(size: size, subjects: subjects),
      ],
    );
  }
}

class Lekser extends StatelessWidget {
  const Lekser({
    Key key,
    @required this.size,
    @required this.subjects,
  }) : super(key: key);

  final Size size;
  final List<ClassModel> subjects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 0,
            left: size.width / 12,
            bottom: size.width / 30,
            right: 0,
          ),
          child: Row(
            children: [
              Text(
                'Lekser',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 38, 58, 80),
                  letterSpacing: 2,
                ),
              ),
              (() {
                if (isTeacher) {
                  return Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: RawMaterialButton(
                        onPressed: () {
                          tider = [];
                          showMaterialModalBottomSheet(
                            context: context,
                            builder: (context) => NewLekse(),
                          );
                        },
                        shape: CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        fillColor: mildBlue,
                        elevation: 0,
                      ),
                    ),
                  );
                } else {
                  return LoadingAnimation();
                }
              }())
            ],
          ),
        ),
        FutureBuilder(
          future: getClassesFromFirebase(context),
          builder: (context, snapshot) {
            print("classes: $classes");

            if (snapshot.connectionState == ConnectionState.done) {
              return FutureBuilder(
                future: _getLekser(context, subjects),
                builder: (context, snapshot) {
                  print("data: ${snapshot.data}");
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      !snapshot.hasError) {
                    List<Widget> rows = [];
                    List<Widget> data = snapshot.data;
                    data.shuffle();
                    int controllNumber = 0;
                    for (var i = 0; i < data.length; i++) {
                      if (controllNumber == 0) {
                        controllNumber = 1;
                        try {
                          rows.add(Row(
                            children: [
                              data[i],
                              data[i + 1],
                            ],
                          ));
                        } catch (e) {
                          rows.add(Row(
                            children: [
                              data[i],
                            ],
                          ));
                        }
                      } else {
                        controllNumber = 0;
                      }
                    }

                    return Column(
                      children: rows,
                    );
                  }
                  return LoadingAnimation();
                },
              );
            }

            return LoadingAnimation();
          },
        ),
      ],
    );
  }
}

Future<List<Widget>> _getLekser(BuildContext context, subjects) async {
  List<Widget> alleLekser = [];
  for (ClassModel classe in classes) {
    List<Widget> lekseList = await _getClassLekser(classe, context, subjects);
    lekseList.forEach((element) {
      alleLekser.add(element);
    });
  }
  print("_getLekser length: ${alleLekser.length}");
  return alleLekser;
}

Future<List<Widget>> _getClassLekser(
  ClassModel classe,
  BuildContext context,
  List<ClassModel> subjects,
) async {
  final List<Widget> widgets = [];
  for (ClassTime classTime in classe.times) {
    for (int day = 0; day < 21; day++) {
      var date = getDate(addDays: day);
      DateTime dateTime = date["dateTime"];
      if (dateTime.weekday == classTime.dayIndex) {
        await getLekserWidgets(context, subjects, date).then((snapshot) {
          print("got $date: $snapshot for ${classe.className}");
          snapshot.forEach((element) {
            widgets.add(element);
          });
        });
      }
    }
  }
  print("${classe.className} length: ${widgets.length}");
  return widgets;
}

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 15.0),
        child: GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Icon(
            Icons.menu,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

class NewLekse extends StatelessWidget {
  const NewLekse({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ModalScrollController.of(context),
      child: Container(
        height: MediaQuery.of(context).size.height / 2 +
            MediaQuery.of(context).viewInsets.bottom,
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              "Ny Lekse",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 38, 58, 80),
                letterSpacing: 2,
              ),
            ),
            (() {
              final node = FocusScope.of(context);

              return Form(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: FormInputField(
                              controller: lekseTitleController,
                              textInputAction: TextInputAction.done,
                              labelText: "Tittel",
                              hintText: "Lekse tittel",
                              onFinish: () {
                                node.nextFocus();
                              },
                              icon: Icon(Icons.title),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          KlasseField()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: FormInputField(
                                controller: lekseBeskController,
                                type: TextInputType.multiline,
                                textInputAction: TextInputAction.done,
                                labelText: "Beskrivelse",
                                hintText: "Lekse beskrivelse",
                                onFinish: () {
                                  node.nextFocus();
                                },
                                icon: Icon(Icons.title),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          KlasseDatoField(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: PurpleButton(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.5,
                          title: "Legg til",
                          onPressed: () async {
                            if (lekseBeskController.text.isEmpty ||
                                lekseTitleController.text.isEmpty ||
                                chossenId == null ||
                                chossenTid == null) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Container(
                                    child: ListTile(
                                      title: Text("Minst et felt er tomt!"),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("ok"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              DocumentReference lekse = db
                                  .collection("classes")
                                  .doc(chossenId)
                                  .collection("classes")
                                  .doc(chossenTid);
                              await getDocument(
                                documentReference: lekse,
                                timeTrigger: Duration(),
                              ).then(
                                (value) {
                                  List lekser;
                                  try {
                                    lekser = value["lekser"];
                                  } catch (e) {
                                    lekser = [];
                                  }

                                  lekser.add({
                                    "tittel": lekseTitleController.text,
                                    "desc": lekseBeskController.text
                                  });
                                  lekse.set({"lekser": lekser});
                                },
                              );
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Container(
                                    child: ListTile(
                                      title: Text("Leksen er lagt til."),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("ok"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    )
                                  ],
                                ),
                              );
                              lekseBeskController.clear();
                              lekseTitleController.clear();
                              print(
                                  "ValgtID: $chossenId, ValgtTid: $chossenTid, tittel: ${lekseTitleController.text}, besk: ${lekseBeskController.text}");
                            }
                          }),
                    ),
                  ],
                ),
              );
            }())
          ],
        ),
      ),
    );
  }
}

class KlasseField extends StatefulWidget {
  const KlasseField({
    Key key,
  }) : super(key: key);

  @override
  _KlasseFieldState createState() => _KlasseFieldState();
}

class _KlasseFieldState extends State<KlasseField> {
  String hintText = "Velg klasse";
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(
        hintText,
        style: TextStyle(color: Colors.black),
      ),
      items: classes.map((ClassModel value) {
        return new DropdownMenuItem<String>(
          value: value.classFirestoreID,
          child: new Text(value.className),
        );
      }).toList(),
      onChanged: (String newValue) {
        tider = [];
        for (ClassModel klasse in classes) {
          if (klasse.classFirestoreID == newValue) {
            chossenId = klasse.classFirestoreID;
            for (ClassTime tid in klasse.times) {
              DateTime date = now;
              while (tid.dayIndex != date.weekday) {
                date = date.add(Duration(days: 1));
              }

              tider.add(date);
              tider.add(date.add(Duration(days: 7)));
            }

            setState(() {
              this.hintText = klasse.className;
            });
          }
        }
      },
    );
  }
}

class KlasseDatoField extends StatefulWidget {
  const KlasseDatoField({
    Key key,
  }) : super(key: key);

  @override
  _KlasseDatoFieldState createState() => _KlasseDatoFieldState();
}

class _KlasseDatoFieldState extends State<KlasseDatoField> {
  String hintText = "Velg klasse";
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(
        hintText,
        style: TextStyle(color: Colors.black),
      ),
      items: tider.map((DateTime value) {
        return new DropdownMenuItem<String>(
          value: "${value.year}.${value.month}.${value.day}",
          child: new Text(
              DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY).format(value)),
        );
      }).toList(),
      onChanged: (String newValue) {
        chossenTid = newValue;
        setState(() {
          this.hintText = newValue;
        });
      },
    );
  }
}

class MinePlaner extends StatelessWidget {
  const MinePlaner({
    Key key,
    @required this.date,
  }) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 25),
          child: Row(
            children: [
              Text(
                'Mine Planer',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 38, 58, 80),
                  letterSpacing: 2,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: RawMaterialButton(
                    onPressed: () {
                      tider = [];
                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => NewLekse(),
                      );
                    },
                    shape: CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(2.5),
                      child: Icon(
                        Icons.notifications,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    fillColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            color: Colors.transparent,
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MenuButton(
                  onPressed: () {
                    currentPageSelected = 0;
                    Navigator.of(context).pushNamed("/dayplan");
                  },
                  color: Color.fromARGB(255, 238, 107, 120),
                  icon: CustomIcons.calendar_check,
                  size: 25,
                  title: "Dagsplan",
                  subTitle: DateFormat("EEEE")
                      .format(
                        getDate(addDays: 0)["dateTime"],
                      )
                      .capitalize(),
                  subTitleOnLong:
                      DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                          .format(
                            getDate()["dateTime"],
                          )
                          .capitalize(),
                ),
                MenuButton(
                  onPressed: () {
                    addWeeks = 0;
                    Navigator.of(context).pushNamed('/weekPlan');
                  },
                  size: 25,
                  color: Colors.blue,
                  title: 'Ukeplan',
                  subTitle: 'Uke ${date.weekOfYear.toString()}',
                  icon: CustomIcons.calendar_alt,
                ),
                MenuButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/testPlan');
                  },
                  size: 25,
                  color: Colors.yellow,
                  title: 'Prøveplan',
                  subTitle: semesterFormatted(
                    getSemester(
                      semesterEn,
                      semesterTo,
                    ),
                  ),
                  icon: CustomIcons.checklist,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MenuButton extends StatefulWidget {
  const MenuButton({
    Key key,
    this.subTitleOnLong,
    @required this.onPressed,
    @required this.size,
    @required this.color,
    @required this.title,
    @required this.subTitle,
    @required this.icon,
  }) : super(key: key);

  final Function onPressed;
  final double size;
  final Color color;
  final String title;
  final String subTitle;
  final String subTitleOnLong;
  final IconData icon;

  @override
  _MenuButtonState createState() => _MenuButtonState(subTitle: subTitle);
}

class _MenuButtonState extends State<MenuButton> {
  _MenuButtonState({this.subTitle});

  String subTitle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      onLongPressEnd: (details) {
        if (widget.subTitleOnLong == null) {
          return;
        }
        setState(() {
          if (subTitle == widget.subTitleOnLong) {
            subTitle = widget.subTitle;
          } else {
            subTitle = widget.subTitleOnLong;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 0),
        child: Row(
          children: [
            RawMaterialButton(
              onPressed: null,
              shape: CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Icon(
                  widget.icon,
                  size: widget.size,
                  color: Colors.white,
                ),
              ),
              fillColor: widget.color,
              elevation: 0,
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                height: 55,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 38, 58, 80),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.99, 1.00),
                      child: Text(
                        subTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BetaHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: NewTopAppBar(),
    );
  }
}

class NewTopAppBar extends StatelessWidget {
  const NewTopAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFab(
      floatingWidget: Container(),
      expandedHeight: MediaQuery.of(context).size.height * 0.2,
      slivers: [
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height * 0.2,
          backgroundColor: Colors.transparent,
          pinned: true,
          floating: true,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
          flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(50),
                ),
              ),
              child: FlexibleSpaceBar(
                  collapseMode: CollapseMode.none,
                  centerTitle: true,
                  title: Text('A Synthwave Mix'))),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Column(
            children: [
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
              ListTile(),
            ],
          )
        ]))
      ],
    );
  }
}

List shuffle(List items) {
// https://stackoverflow.com/questions/13554129/list-shuffle-in-dart
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}

main() {
  var items = ['foo', 'bar', 'baz', 'qux'];

  print(shuffle(items));
}
