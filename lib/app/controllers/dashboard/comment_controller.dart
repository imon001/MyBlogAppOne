import 'package:blog/app/constants/app_string.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/services/comment_service.dart';
import 'package:get/get.dart';

import '../../models/dashboard/comment.dart';

class CommentController extends GetxController {
  final _commentService = CommentService();
  var comments = <Comment>[].obs;
  final gettingComments = false.obs;

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
      } else if (response.error == UN_AUTHERNTICATED) {
        logOut();
        gettingComments.value = false;
      } else {
        gettingComments.value = false;
      }
    }
  }
}
