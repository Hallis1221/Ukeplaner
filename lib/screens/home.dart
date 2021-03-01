/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/logic/firebase/auth_services.dart';
import 'package:ukeplaner/logic/firebase/firebase.dart';
import 'package:ukeplaner/screens/login.dart';
import '../icons/date_picker_check_mark_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250),
        child: Stack(
          alignment: Alignment.topRight,
          children: [TopDecorationHalfCircle()],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 25),
            child: Text(
              'Mine Planer',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 38, 58, 80),
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              color: Colors.transparent,
              width: 400,
              height: MediaQuery.of(context).size.width / 1.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MenuButton(
                    onPressed: () {
                      print('Hei');
                    },
                    color: Color.fromARGB(255, 238, 107, 120),
                    icon: Icons.library_add_check_rounded,
                    size: 25,
                    title: "Dagsplan",
                    subTitle: "Mandag",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key key,
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
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onPressed,
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
                  icon,
                  size: size,
                  color: Colors.white,
                ),
              ),
              fillColor: color,
              elevation: 0,
            ),
            Container(
              color: Colors.transparent,
              width: 200,
              height: 55,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 38, 58, 80),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
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
            )
          ],
        ),
      ),
    );
  }
}
