// ignore_for_file: prefer_const_constructors

import 'package:blog/app/constants/api_string.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/models/auth/user.dart';
import 'package:blog/app/models/dashboard/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.comment,
  });
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    User user = comment.user != null ? comment.user as User : User();
    String avatar = user.avatar ?? "";
    String avatarUrl = imageBaseUrl + avatar;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
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
                        height: 70.w,
                        width: 70.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                          image: DecorationImage(
                            image: NetworkImage(avatarUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
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
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? "",
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 0.w,
                      ),
                      Text(
                        comment.text ?? "",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(
                        height: 5.w,
                      ),
                      Row(
                        children: [
                          Text(
                            getTimeAgo(comment.createdAt ?? ""),
                            style: TextStyle(
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("|"),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${comment.replyCount ?? 0} replies ',
                            style: TextStyle(
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("|"),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Reply',
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("|"),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Delete',
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
