// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:blog/app/constants/api_string.dart';
import 'package:blog/app/constants/colors.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/controllers/dashboard/blog_post_controller.dart';
import 'package:blog/app/models/auth/user.dart';
import 'package:blog/app/models/dashboard/blog_post.dart';
import 'package:blog/app/models/dashboard/post_category.dart';
import 'package:blog/app/views/dashboard/home/post_details_view.dart';
import 'package:blog/app/views/dashboard/post/edit%20post/edit_post_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.blogPost,
    required this.index,
    required this.isDeleted,
    required this.isSaved,
  });
  final BlogPost blogPost;
  final int index;
  final bool isDeleted;
  final bool isSaved;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => PostDetailsView(blogPost: blogPost));
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleAndMoreButton(context),
              SizedBox(
                height: 5.w,
              ),
              _userNameAndAvatar(),
              SizedBox(
                height: 5.w,
              ),
              _categoryAndDate(),
              SizedBox(
                height: 15.w,
              ),
              _description(),
              SizedBox(
                width: 5.w,
              ),
              _thumnailImage(),
              SizedBox(
                width: 5.w,
              ),
              _likeAndComment()
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleAndMoreButton(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            blogPost.title ?? "",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        PopupMenuButton(onSelected: (value) {
          switch (value) {
            case 'save':
              Get.find<BlogPostController>().savePost(blogPost.id ?? "");

              break;
            case 'edit':
              Get.to(() => EditPostView(
                    blogPost: blogPost,
                  ));
              break;
            case 'delete':
              Get.find<BlogPostController>().deletePost(blogPost.id ?? "", index);
              break;
            case 'permanent_delete':
              Get.find<BlogPostController>().deletePostPermanent(blogPost.id ?? "", index);
              break;
            case 'remove':
              Get.find<BlogPostController>().removeSavedPost(blogPost.id ?? "", index);
              break;

            default:
          }
        }, itemBuilder: (context) {
          User owner = blogPost.user != null ? blogPost.user as User : User();

          return <PopupMenuItem>[
            if (owner.id != userId && !isSaved)
              PopupMenuItem(
                  value: 'save',
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 16.sp),
                  )),
            if (owner.id != userId && isSaved)
              PopupMenuItem(
                  value: 'remove',
                  child: Text(
                    'Remove',
                    style: TextStyle(fontSize: 16.sp),
                  )),
            if (owner.id == userId && !isDeleted)
              PopupMenuItem(
                  value: 'edit',
                  child: Text(
                    'Edit',
                    style: TextStyle(fontSize: 16.sp),
                  )),
            if (owner.id == userId && !isDeleted)
              PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Delete',
                    style: TextStyle(fontSize: 16.sp),
                  )),
            if (owner.id == userId && isDeleted)
              PopupMenuItem(
                  value: 'permanent_delete',
                  child: Text(
                    'Delete Permanently',
                    style: TextStyle(fontSize: 16.sp),
                  )),
          ];
        })
        // GestureDetector(
        //   child: Icon(Icons.more_vert),
        //   onTap: () {

        //   },
        // )
      ],
    );
  }

  Widget _userNameAndAvatar() {
    var user = blogPost.user != null ? blogPost.user as User : User();
    var name = user.name ?? "";
    var avatar = user.avatar ?? "";
    var avatarLink = imageBaseUrl + avatar;
    return Row(
      children: [
        if (avatar.isEmpty)
          Container(
            height: 25.w,
            width: 25.w,
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
            height: 25.w,
            width: 25.w,
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
          width: 5.w,
        ),
        Text(
          name,
          style: TextStyle(fontSize: 16.sp),
        ),
      ],
    );
  }

  Widget _categoryAndDate() {
    var category = blogPost.category != null ? blogPost.category as PostCategory : PostCategory();
    var categoryName = category.name ?? "";
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                categoryName,
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
        ),
        Text(
          getCustomeDate(blogPost.createdAt ?? ""),
          style: TextStyle(fontSize: 16.sp),
        )
      ],
    );
  }

  Widget _description() {
    return Text(
      blogPost.description ?? "",
      style: TextStyle(fontSize: 16.sp),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _thumnailImage() {
    var thumnail = blogPost.thumbnail ?? "";

    var thumnailImage = imageBaseUrl + thumnail;

    return thumnailImage.isEmpty
        ? Container()
        : SizedBox(
            child: Image.network(
              thumnailImage,
              height: 180.w,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
  }

  Widget _likeAndComment() {
    bool isLiked = blogPost.isLiked ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: MaterialButton(
            onPressed: () {
              Get.find<BlogPostController>().likeUnlike(blogPost.id ?? "", index);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.thumb_up,
                  size: 22.sp,
                  color: isLiked ? kBaseColor : Colors.black87,
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  "${blogPost.likeCount}",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                )
              ],
            ),
          ),
        ),
        Text(
          '|',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: MaterialButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.comment,
                  size: 22.sp,
                  color: Colors.black87,
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  "${blogPost.commentCount}",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
