// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/dashboard/blog_post_controller.dart';
import '../../../../models/dashboard/blog_post.dart';
import '../../home/widget/post_card.dart';

class SavePostView extends StatefulWidget {
  const SavePostView({super.key});

  @override
  State<SavePostView> createState() => _SavePostViewState();
}

class _SavePostViewState extends State<SavePostView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Posts'),
        centerTitle: true,
        elevation: 5,
      ),
      body: SafeArea(child: Obx(() {
        var savedPost = Get.find<BlogPostController>().savedPost;
        var loading = Get.find<BlogPostController>().getSavingPosts.value;

        return loading
            ? Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                ),
              )
            : savedPost.isEmpty
                ? Center(
                    child: Text(
                      'No data found:(',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView(
                    children: List.generate(savedPost.length, (index) {
                      BlogPost post = savedPost[index];
                      return PostCard(
                        blogPost: post,
                        index: index,
                        isDeleted: false,
                        isSaved: true,
                      );
                    }),
                  );
      })),
    );
  }
}
