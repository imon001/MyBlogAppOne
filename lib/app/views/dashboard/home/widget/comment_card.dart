// ignore_for_file: prefer_const_constructors

import 'package:blog/app/constants/api_string.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/controllers/dashboard/comment_controller.dart';
import 'package:blog/app/models/auth/user.dart';
import 'package:blog/app/models/dashboard/comment.dart';
import 'package:blog/app/views/dashboard/home/widget/replies_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.commentIndex,
    required this.postIndex,
  });
  final Comment comment;

  final int commentIndex, postIndex;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final _key = GlobalKey<FormState>();
  final _replycontroller = TextEditingController();

  @override
  void dispose() {
    _replycontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.comment.user != null ? widget.comment.user as User : User();
    String avatar = user.avatar ?? "";
    String avatarUrl = imageBaseUrl + avatar;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0.w),
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
                          image: DecorationImage(image: NetworkImage(avatarUrl), fit: BoxFit.cover),
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
                    widget.comment.text ?? "",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 5.w),
                  Row(children: [
                    Text(
                      getTimeAgo(widget.comment.createdAt ?? ""),
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    SizedBox(width: 5.w),
                    Text("|"),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        final controller = Get.find<CommentController>();
                        controller.selectedCommentIndex.value = widget.commentIndex;

                        if (controller.selectedCommentIndex.value == widget.commentIndex) {
                          controller.showReply.value = !controller.showReply.value;
                          if (controller.showReply.value) {
                            controller.getReplies(widget.comment.id ?? "");
                          } else {
                            controller.showReplyEntry.value = false;
                          }
                        }
                      },
                      child: Text(
                        '${widget.comment.replyCount ?? 0} replies ',
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text("|"),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        final controller = Get.find<CommentController>();
                        controller.selectedCommentIndex.value = widget.commentIndex;

                        if (controller.selectedCommentIndex.value == widget.commentIndex) {
                          controller.showReplyEntry.value = !controller.showReplyEntry.value;

                          if (controller.showReplyEntry.value) {
                            controller.getReplies(widget.comment.id ?? "");

                            if (!controller.showReply.value) {
                              controller.showReply.value = true;
                            }
                          } else {
                            controller.showReply.value = false;
                          }
                        }
                      },
                      child: Text(
                        'Reply',
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    if (user.id == userId) Text("|"),
                    SizedBox(width: 5.w),
                    if (user.id == userId)
                      GestureDetector(
                          onTap: () {
                            Get.find<CommentController>().deleteComment(widget.comment.id ?? "", widget.commentIndex, widget.postIndex);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                          ))
                  ]),
                ]))
              ],
            ),
            //SizedBox(height: 10.w),
            Column(
              children: [
                Padding(padding: EdgeInsets.only(left: 18.0.w), child: _repliesCard(widget.commentIndex)),
              ],
            ),
            SizedBox(height: 10.w),
            Divider()
          ],
        ),
      ),
    );
  }

  Widget _repliesCard(int commentIndex) {
    return Obx(() {
      final controller = Get.find<CommentController>();
      var replies = controller.replies;
      int selectedIndex = controller.selectedCommentIndex.value;
      bool showReply = controller.showReply.value;
      bool showReplyEntry = controller.showReplyEntry.value;

      return Column(
        children: [
          showReply
              ? selectedIndex == commentIndex
                  ? Column(
                      children: List.generate(replies.length, (index) {
                        return ReplyCard(
                          reply: replies[index],
                          replyIndex: index,
                          commentIndex: widget.commentIndex,
                        );
                      }),
                    )
                  : Container()
              : Container(),
          showReplyEntry
              ? selectedIndex == commentIndex
                  ? _replyEntryCard()
                  : Container()
              : Container(),
        ],
      );
    });
  }

  Widget _replyEntryCard() {
    final controller = Get.find<CommentController>();
    return Form(
      key: _key,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          style: TextStyle(fontSize: 14.w),
          decoration: InputDecoration(
            hintText: "Reply",
            hintStyle: TextStyle(fontSize: 14.w),
            suffixIcon: IconButton(
              onPressed: () async {
                if (_key.currentState!.validate()) {
                  _key.currentState!.save();
                  bool created = await controller.createReply(widget.comment.id ?? "", widget.commentIndex);

                  if (created) {
                    _replycontroller.clear();
                    controller.replyText = "";
                    controller.isReplyTyping.value = false;
                  }
                }
              },
              icon: Obx(() {
                return Icon(
                  Icons.send,
                  color: controller.isReplyTyping.value ? kBaseColor : Colors.black87,
                );
              }),
            ),
          ),
          controller: _replycontroller,
          onSaved: (value) {
            controller.replyText = value ?? "";
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              controller.isReplyTyping.value = true;
            } else {
              controller.isReplyTyping.value = false;
            }
          },
        ),
      ),
    );
  }
}
