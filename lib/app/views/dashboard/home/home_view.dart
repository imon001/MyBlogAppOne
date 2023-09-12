// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:async';

import 'package:blog/app/constants/app_string.dart';
import 'package:blog/app/constants/colors.dart';
import 'package:blog/app/controllers/dashboard/blog_post_controller.dart';
import 'package:blog/app/controllers/dashboard/home_controller.dart';
import 'package:blog/app/models/dashboard/blog_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'widget/category_dropdown.dart';
import 'widget/post_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TextEditingController _searchController;

  Timer? _debounceTimer;
  void debouncing({
    required Function() fn,
    int waitForMs = 800,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChaged);
    super.initState();
  }

  _onSearchChaged() {
    debouncing(fn: () {
      Get.find<BlogPostController>().searchPost(_searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override //this is extra override added
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: kBaseColor,
        title: Obx(() {
          bool searching = Get.find<HomeController>().isSearching.value;
          return searching
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.w,
                    horizontal: 12.w,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "search",
                      hintStyle: TextStyle(fontSize: 18.sp),
                      filled: true,
                      fillColor: whiteColor,
                      suffixIcon: IconButton(
                          onPressed: () {
                            Get.find<HomeController>().isSearching.value = false;
                          },
                          icon: Icon(Icons.close_rounded)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 6.w),
                    ),
                    controller: _searchController,
                  ),
                )
              : Text(APP_NAME);
        }),
        centerTitle: true,
        elevation: 0,
        actions: [
          Obx(() {
            bool searching = Get.find<HomeController>().isSearching.value;
            return searching
                ? Container()
                : IconButton(
                    onPressed: () {
                      Get.find<HomeController>().isSearching.value = true;
                    },
                    icon: Icon(Icons.search),
                  );
          })
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.w),
        child: Column(
          children: [
            CategoryDropdown(),
            SizedBox(
              height: 5.w,
            ),
            Expanded(child: Obx(() {
              var posts = Get.find<BlogPostController>().allPost;
              var loading = Get.find<BlogPostController>().loadingData.value;

              return loading
                  ? Center(
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : posts.isEmpty
                      ? Center(
                          child: Text(
                            'No data found:(',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : ListView(
                          children: List.generate(posts.length, (index) {
                            BlogPost post = posts[index];
                            return PostCard(
                              blogPost: post,
                              index: index,
                              isDeleted: false,
                              isSaved: false,
                            );
                          }),
                        );
            })),
          ],
        ),
      )),
    );
  }
}
