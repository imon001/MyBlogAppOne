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
      body: SafeArea(child: Obx(
        () {
          var savedPost = Get.find<BlogPostController>().savedPost;
          return savedPost.isNotEmpty
              ? ListView(
                  children: List.generate(savedPost.length, (index) {
                    BlogPost blogPost = savedPost[index];
                    return PostCard(
                      blogPost: blogPost,
                      index: index,
                      isDeleted: false,
                      isSaved: true,
                    );
                  }),
                )
              : const Center(
                  child: Text('Nothing found!'),
                );
        },
      )),
    );
  }
}
