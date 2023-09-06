// ignore_for_file: prefer_const_constructors

import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/views/dashboard/post/deleted_posts/deleted_post_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              onPressed: () {},
              child: Text('all saved posts'),
            ),
            MaterialButton(
              onPressed: () {
                Get.to(() => DeletedPostView());
              },
              child: Text('all deleted posts'),
            ),
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
