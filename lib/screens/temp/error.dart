/* Copyright (C) 2021 Halvor Vivelstad - All Rights Reserved
 You may not use, distribute and modify this code unless a license is granted. 
 If so use, distribution and modification can be done under the terms of the license.*/

import 'package:flutter/material.dart';
import '../../logic/firebase/auth_services.dart';
import 'package:provider/provider.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => context.read<AuthenticationService>().signOut(),
          child: Text(
            "Something went wrong...",
          ),
        ),
      ),
    );
  }
}
