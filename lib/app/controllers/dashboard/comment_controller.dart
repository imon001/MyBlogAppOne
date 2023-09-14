import 'dart:convert';
import 'package:blog/app/constants/app_string.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/controllers/dashboard/blog_post_controller.dart';
import 'package:blog/app/models/dashboard/comment_response.dart';
import 'package:blog/app/models/response_status.dart';
import 'package:blog/app/services/comment_service.dart';
import 'package:get/get.dart';

import '../../models/dashboard/comment.dart';

class CommentController extends GetxController {
  final _commentService = CommentService();
  var comments = <Comment>[].obs;
  var gettingComments = false.obs;
  var creatingComments = false.obs;
  var isCommentTyping = false.obs;
  var isCommentDeleting = false.obs;
  String commentText = "";

  getComments(String postId) async {
    if (!gettingComments.value) {
      gettingComments.value = true;
      comments.clear();

      final response = await _commentService.getComments(postId);

      if (response.error == null) {
        var commentLists = response.data != null ? response.data as List<dynamic> : [];

        for (var item in commentLists) {
          comments.add(item);
        }
        gettingComments.value = false;
      } else if (response.error == UN_AUTHERNTICATED) {
        logOut();
        gettingComments.value = false;
      } else {
        gettingComments.value = false;
      }
    }
  }

  Future<bool> createComment(String postId, int postIndex) async {
    bool created = false;
    if (!creatingComments.value && commentText.isNotEmpty) {
      creatingComments.value = true;
      var body = jsonEncode({
        "text": commentText.trim(),
        "postId": postId,
      });

      final response = await _commentService.createComments(body);

      if (response.error == null) {
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();
        bool success = responseStatus.success ?? false;
        if (success) {
          final commentResponse = responseStatus.data != null ? responseStatus.data as CommentResponse : CommentResponse();
          final comment = commentResponse.comment != null ? commentResponse.comment as Comment : Comment();
          comments.add(comment);
          created = true;
          final post = Get.find<BlogPostController>().allPost[postIndex];
          post.commentCount = commentResponse.commentCount ?? 0;
          Get.find<BlogPostController>().allPost[postIndex] = post;
          creatingComments.value = false;
        } else {
          showError(error: response.error ?? "");
          creatingComments.value = false;
        }
      } else if (response.error == UN_AUTHERNTICATED) {
        logOut();
        creatingComments.value = false;
      } else {
        showError(error: response.error ?? "");
        creatingComments.value = false;
      }
    }
    return created;
  }

  deleteComment(String commentId, int commentIndex, int postIndex) async {
    if (!isCommentDeleting.value) {
      isCommentDeleting.value = true;

      final response = await _commentService.deleteComments(commentId);
      if (response.error == null) {
        final status = response.data != null ? response.data as ResponseStatus : ResponseStatus();
        bool success = status.success ?? false;
        if (success) {
          final post = Get.find<BlogPostController>().allPost[postIndex];
          int count = post.commentCount ?? 0;

          post.commentCount = count != 0 ? count - 1 : count;

          Get.find<BlogPostController>().allPost[postIndex] = post;

          comments.removeAt(commentIndex);

          isCommentDeleting.value = false;
        } else {
          showError(error: response.error ?? "");
          isCommentDeleting.value = false;
        }
      } else if (response.error == UN_AUTHERNTICATED) {
        logOut();
        isCommentDeleting.value = false;
      } else {
        showError(error: response.error ?? "");
        isCommentDeleting.value = false;
      }
    }
  }
}
