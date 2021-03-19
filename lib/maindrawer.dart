import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ukeplaner/config/config.dart';
import 'package:provider/provider.dart';
import 'package:ukeplaner/logic/firebase/auth_services.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: FutureBuilder(
                future: getUser(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    User user = snapshot.data();
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(""),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "$firstName $lastName",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                })),
      ),
      SizedBox(
        height: 20.0,
      ),
      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.person,
          color: Colors.black,
        ),
        title: Text("Your Profile"),
      )
    ]);
  }
}

Future<User> getUser(
  context,
) async {
  User user;
  await context.read<AuthenticationService>().getCurrentUser().then((value) {
    user = value;
  });
  return user;
}
