import 'package:flutter/material.dart';
import 'package:ukeplaner/logic/oss_license.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Innstilinger"),
      ),
      body: Column(
        children: [
          Column(
            children: <ListTile>[
              ListTile(
                leading: Icon(Icons.file_present),
                title: Text(
                  "Lisenser",
                ),
                onTap: () => Navigator.of(context).pushNamed('/licenses'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
