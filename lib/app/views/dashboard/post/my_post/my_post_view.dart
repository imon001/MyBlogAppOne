// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/dashboard/blog_post_controller.dart';
import '../../../../models/dashboard/blog_post.dart';
import '../../home/widget/post_card.dart';

class MyPostView extends StatefulWidget {
  const MyPostView({super.key});

  @override
  State<MyPostView> createState() => _MyPostViewState();
}

class _MyPostViewState extends State<MyPostView> {
  @override
  void initState() {
    Get.find<BlogPostController>().getMyPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
        centerTitle: true,
        elevation: 5,
      ),
      body: SafeArea(child: Obx(() {
        var myPost = Get.find<BlogPostController>().myPosts;
        var loading = Get.find<BlogPostController>().gettingMyPost.value;

        return loading
            ? Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                ),
              )
            : myPost.isEmpty
                ? Center(
                    child: Text(
                      'No data found:(',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView(
                    children: List.generate(myPost.length, (index) {
                      BlogPost post = myPost[index];
                      return PostCard(
                        blogPost: post,
                        index: index,
                        isDeleted: false,
                        isSaved: false,
                      );
                    }),
                  );
      })),
    );
  }
}
