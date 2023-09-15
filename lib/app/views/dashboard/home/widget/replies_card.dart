// ignore_for_file: prefer_const_constructors

import 'package:blog/app/constants/api_string.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/models/auth/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controllers/dashboard/comment_controller.dart';
import '../../../../models/dashboard/reply.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({
    super.key,
    required this.reply,
    required this.replyIndex,
    required this.commentIndex,
  });
  final Reply reply;

  final int commentIndex, replyIndex;

  @override
  Widget build(BuildContext context) {
    User user = reply.user != null ? reply.user as User : User();
    String avatar = user.avatar ?? "";
    String avatarUrl = imageBaseUrl + avatar;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  avatar.isNotEmpty
                      ? Container(
                          height: 60.w,
                          width: 60.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            image: DecorationImage(image: NetworkImage(avatarUrl), fit: BoxFit.cover),
                          ),
                        )
                      : Container(
                          height: 60.w,
                          width: 60.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/default_user.jpg',
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      user.name ?? "",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.w),
                    Text(
                      reply.text ?? "",
                      style: TextStyle(fontSize: 16.sp),
                      // maxLines: 3,
                      // overflow: TextOverflow.ellipsis
                    ),
                    SizedBox(height: 5.w),
                    Row(children: [
                      Text(
                        getTimeAgo(reply.createdAt ?? ""),
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(width: 5.w),
                      if (user.id == userId) Text("|"),
                      SizedBox(width: 5.w),
                      if (user.id == userId)
                        GestureDetector(
                            onTap: () {
                              Get.find<CommentController>().deleteReply(reply.id ?? "", replyIndex, commentIndex);
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                            ))
                    ]),
                  ]))
                ],
              ),
              SizedBox(height: 10.w),
            ],
          ),
        ),
      ),
    );
  }
}
