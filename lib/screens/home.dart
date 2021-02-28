/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/logic/firebase/auth_services.dart';
import 'package:ukeplaner/logic/firebase/firebase.dart';
import 'package:ukeplaner/screens/login.dart';

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
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 50),
            child: Text(
              'Mine Planer',
              style: TextStyle(fontSize: 22),
            ),
          )
        ],
      ),
    );
  }
}
