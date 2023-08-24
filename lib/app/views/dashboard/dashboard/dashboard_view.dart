// ignore_for_file: prefer_const_constructors, unused_import, unused_field

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../controllers/dashboard/home_controller.dart';
import '../../../controllers/dashboard/blog_post_controller.dart';
import '../home/home_view.dart';
import '../post/create_post/create_post_view.dart';
import '../profile/profile_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _homeController = Get.put(HomeController());
  final _blogPostController = Get.put(BlogPostController());
  int selectedIndex = 0;

  List<Widget> pages = [HomeView(), ProfileView()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.brown,
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(content: Text('Tap back again to leave')),
          child: SafeArea(
            child: pages[selectedIndex],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kBaseColor2,
          shape: CircleBorder(),
          onPressed: () {
            Get.to(() => const CreatePostView());
          },
          child: Icon(Icons.add, size: 20.sp),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            backgroundColor: kBaseColor,
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home, size: 25.sp), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person, size: 25.sp), label: 'Profile'),
            ]));
  }
}
