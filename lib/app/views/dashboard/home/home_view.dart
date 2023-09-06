// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:blog/app/constants/colors.dart';
import 'package:blog/app/controllers/dashboard/blog_post_controller.dart';
import 'package:blog/app/models/dashboard/blog_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'widget/category_dropdown.dart';
import 'widget/post_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: kBaseColor,
        title: Text('Daily Blogs'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
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
