// ignore_for_file: prefer_const_constructors

import 'package:blog/app/views/dashboard/post/edit%20post/edit_post_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/api_string.dart';
import '../../../constants/colors.dart';
import '../../../constants/helper_function.dart';
import '../../../models/auth/user.dart';
import '../../../models/dashboard/blog_post.dart';
import '../../../models/dashboard/post_category.dart';

class PostDetailsView extends StatelessWidget {
  const PostDetailsView({super.key, required this.blogPost});

  final BlogPost blogPost;

  @override
  Widget build(BuildContext context) {
    User owner = blogPost.user != null ? blogPost.user as User : User();

    return Scaffold(
      appBar: AppBar(
        title: Text("details Page"),
        centerTitle: true,
        backgroundColor: kBaseColor,
        elevation: 0,
        actions: [
          if (owner.id == userId)
            IconButton(
                onPressed: () {
                  Get.to(() => EditPostView(
                        blogPost: blogPost,
                      ));
                },
                icon: Icon(Icons.edit_note))
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 5.w,
        ),
        child: ListView(
          children: [
            _titleCategoryDateAndDescription(),
            SizedBox(
              height: 5.w,
            ),
            _thumbnail(),
            _images(),
            SizedBox(
              height: 5.w,
            ),
            _authorDetails(),
            SizedBox(
              height: 5,
            ),
            _commentsDetails(),
            SizedBox(
              height: 20,
            )
          ],
        ),
      )),
    );
  }

  Widget _titleCategoryDateAndDescription() {
    final category = blogPost.category != null ? blogPost.category as PostCategory : PostCategory();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          blogPost.title ?? "",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25.sp),
        ),
        SizedBox(
          height: 5.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.name ?? "",
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              getCustomeDate(blogPost.createdAt ?? ""),
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
        SizedBox(
          height: 10.w,
        ),
        Text(
          blogPost.description ?? "",
          style: TextStyle(fontSize: 16.sp),
          textAlign: TextAlign.justify,
        )
      ],
    );
  }

  Widget _thumbnail() {
    final thumbnail = blogPost.thumbnail != null ? blogPost.thumbnail as String : "";
    final thumbnailLink = imageBaseUrl + thumbnail;
    return thumbnail.isEmpty
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 3.w),
            child: Image.network(
              thumbnailLink,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          );
  }

  Widget _images() {
    final images = (blogPost.images != null) || (blogPost.images!.isNotEmpty) ? blogPost.images as List<String> : <String>[];
    return Column(
      children: List.generate(images.length, (index) {
        String image = images[index];
        String imageUrl = imageBaseUrl + image;

        return image.isEmpty
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 3.w),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              );
      }),
    );
  }

  Widget _authorDetails() {
    final user = blogPost.user != null ? blogPost.user as User : User();
    var avatar = user.avatar ?? "";
    var avatarLink = imageBaseUrl + avatar;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.w),
      child: Column(
        children: [
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0.w),
            child: Row(
              children: [
                if (avatar.isEmpty)
                  Container(
                    height: 70.w,
                    width: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/default_user.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (avatar.isNotEmpty)
                  Container(
                    height: 70.w,
                    width: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      image: DecorationImage(
                        image: NetworkImage(avatarLink),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? "",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 3.w,
                    ),
                    Text(
                      user.shortBio ?? "",
                      style: TextStyle(
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(
                      height: 3.w,
                    ),
                    Text(
                      "total ${user.postCount} post",
                      style: TextStyle(
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _commentsDetails() {
    int comments = blogPost.commentCount ?? 0;

    return comments > 0
        ? Text(
            'total ($comments) comments',
            style: TextStyle(fontSize: 16.sp),
          )
        : Text(
            'No comments yet!',
            style: TextStyle(fontSize: 16.sp),
            textAlign: TextAlign.center,
          );
  }
}
