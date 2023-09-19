// ignore_for_file: prefer_const_constructors

import 'package:blog/app/controllers/dashboard/blog_post_controller.dart';
import 'package:blog/app/models/dashboard/blog_post.dart';
import 'package:blog/app/views/dashboard/home/widget/post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeletedPostView extends StatelessWidget {
  const DeletedPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deleted Posts'),
        centerTitle: true,
        elevation: 5,
      ),
      body: SafeArea(child: Obx(() {
        var deletedPost = Get.find<BlogPostController>().deletedPost;
        var loading = Get.find<BlogPostController>().getDeletedPosts.value;

        return loading
            ? Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                ),
              )
            : deletedPost.isEmpty
                ? Center(
                    child: Text(
                      'No data found:(',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView(
                    children: List.generate(deletedPost.length, (index) {
                      BlogPost post = deletedPost[index];
                      return PostCard(
                        blogPost: post,
                        index: index,
                        isDeleted: true,
                        isSaved: false,
                      );
                    }),
                  );
      })),
    );
  }
}
