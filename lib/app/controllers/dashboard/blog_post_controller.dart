import 'package:blog/app/models/dashboard/like_unlike.dart';
import 'package:blog/app/models/response_status.dart';
import 'package:get/get.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/dashboard/blog_post.dart';
import '../../services/post_service.dart';

class BlogPostController extends GetxController {
  final _postService = PostService();
  var allPost = <BlogPost>[].obs;

  var loadingData = false.obs;
  var likeUnlikeLoading = false.obs;
  //var selectedCategoryId = "";

  getAllPost() async {
    loadingData.value = true;
    var response = await _postService.getAllPost();
    if (response.error == null) {
      var postList = response.data != null ? response.data as List<dynamic> : [];

      allPost.clear();
      for (var item in postList) {
        allPost.add(item);
      }
      loadingData.value = false;
    } else if (response.error == UN_AUTHERNTICATED) {
      logOut();
      loadingData.value = false;
    }
  }

  likeUnlike(String postId, int index) async {
    if (!likeUnlikeLoading.value) {
      likeUnlikeLoading.value = true;
      final response = await _postService.likeUnlike(postId);

      if (response.error == null) {
        final responsestatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = responsestatus.success ?? false;
        if (success) {
          LikeUnlike likeUnlike = responsestatus.data != null ? responsestatus.data as LikeUnlike : LikeUnlike();
          final post = allPost[index];

          post.isLiked = likeUnlike.isLiked ?? false;
          post.likeCount = likeUnlike.likeCount ?? 0;
          allPost[index] = post;
        } else {
          showError(error: responsestatus.message ?? "");
        }

        likeUnlikeLoading.value = false;
      } else if (response.error == UN_AUTHERNTICATED) {
        likeUnlikeLoading.value = false;

        logOut();
      } else {
        likeUnlikeLoading.value = false;

        showError(error: response.error ?? "");
      }
    }
  }

  @override
  void onInit() {
    getAllPost();
    super.onInit();
  }
}
