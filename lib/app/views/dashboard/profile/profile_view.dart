// ignore_for_file: prefer_const_constructors

import 'package:blog/app/constants/helper_function.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile View'),
            MaterialButton(
              onPressed: () {
                logOut();
              },
              child: Text('Log Out'),
            )
          ],
        ),
      )),
    );
  }
}
