// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field
import 'package:blog/app/controllers/dashboard/comment_controller.dart';
import 'package:blog/app/views/dashboard/home/widget/comment_card.dart';
import 'package:blog/app/views/dashboard/post/edit%20post/edit_post_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/api_string.dart';
import '../../../constants/colors.dart';
import '../../../constants/helper_function.dart';
import '../../../models/auth/user.dart';
import '../../../models/dashboard/blog_post.dart';
import '../../../models/dashboard/comment.dart';
import '../../../models/dashboard/post_category.dart';

class PostDetailsView extends StatefulWidget {
  const PostDetailsView({super.key, required this.blogPost, required this.deletedPost, required this.postIndex});

  final BlogPost blogPost;
  final bool deletedPost;
  final int postIndex;

  @override
  State<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<PostDetailsView> {
  final _commentKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  @override
  void dispose() {
    disposeVariables();
    super.dispose();
  }

  disposeVariables() {
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      if (Get.isRegistered<CommentController>()) {
        final controller = Get.find<CommentController>();
        controller.comments.clear();
      }
      _commentController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    User owner = widget.blogPost.user != null ? widget.blogPost.user as User : User();

    Get.find<CommentController>().getComments(widget.blogPost.id ?? "");

    return Scaffold(
      appBar: AppBar(
        title: Text("details Page"),
        centerTitle: true,
        backgroundColor: kBaseColor,
        elevation: 0,
        actions: [
          if (owner.id == userId && !widget.deletedPost)
            IconButton(
                onPressed: () {
                  Get.to(() => EditPostView(
                        blogPost: widget.blogPost,
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
            // _commentsDetails(),
            SizedBox(height: 10),
            _comments(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      )),
    );
  }

  Widget _titleCategoryDateAndDescription() {
    final category = widget.blogPost.category != null ? widget.blogPost.category as PostCategory : PostCategory();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.blogPost.title ?? "",
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
              getCustomeDate(widget.blogPost.createdAt ?? ""),
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
        SizedBox(
          height: 10.w,
        ),
        Text(
          widget.blogPost.description ?? "",
          style: TextStyle(fontSize: 16.sp),
          textAlign: TextAlign.justify,
        )
      ],
    );
  }

  Widget _thumbnail() {
    final thumbnail = widget.blogPost.thumbnail != null ? widget.blogPost.thumbnail as String : "";
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
    final images = (widget.blogPost.images != null) || (widget.blogPost.images!.isNotEmpty) ? widget.blogPost.images as List<String> : <String>[];
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
    final user = widget.blogPost.user != null ? widget.blogPost.user as User : User();
    var avatar = user.avatar ?? "";
    var avatarLink = imageBaseUrl + avatar;
    return Column(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? "",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                ),
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  // Widget _commentsDetails() {
  //   int comments = widget.blogPost.commentCount ?? 0;

  //   return comments > 0
  //       ? Text(
  //           'total ($comments) comments',
  //           style: TextStyle(fontSize: 16.sp),
  //         )
  //       : Text(
  //           'No comments yet!',
  //           style: TextStyle(fontSize: 16.sp),
  //           textAlign: TextAlign.center,
  //         );
  // }

  Widget _comments() => Column(
        children: [
          Obx(() {
            final comments = Get.find<CommentController>().comments;

            return Column(
              children: [
                comments.isEmpty
                    ? Text(
                        'No comments yet!',
                        style: TextStyle(fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      )
                    : Column(
                        children: List.generate(comments.length, (index) {
                          Comment comment = comments[index];
                          return CommentCard(
                            comment: comment,
                            commentIndex: index,
                            postIndex: widget.postIndex,
                          );
                        }),
                      ),
                _commentEntryCard()
              ],
            );
          })
        ],
      );

  Widget _commentEntryCard() {
    final controller = Get.find<CommentController>();
    return Form(
      key: _commentKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          style: TextStyle(fontSize: 14.w),
          decoration: InputDecoration(
            hintText: "Comment",
            hintStyle: TextStyle(fontSize: 14.w),
            suffixIcon: IconButton(
              onPressed: () async {
                if (_commentKey.currentState!.validate()) {
                  _commentKey.currentState!.save();
                  bool created = await controller.createComment(widget.blogPost.id ?? "", widget.postIndex);

                  if (created) {
                    _commentController.clear();
                    controller.commentText = "";
                    controller.isCommentTyping.value = false;
                  }
                }
              },
              icon: Obx(() {
                return Icon(
                  Icons.send,
                  color: controller.isCommentTyping.value ? kBaseColor : Colors.black87,
                );
              }),
            ),
          ),
          controller: _commentController,
          onSaved: (value) {
            controller.commentText = value ?? "";
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              controller.isCommentTyping.value = true;
            } else {
              controller.isCommentTyping.value = false;
            }
          },
        ),
      ),
    );
  }
}
