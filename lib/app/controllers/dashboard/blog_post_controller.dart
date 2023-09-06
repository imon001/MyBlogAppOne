import 'package:blog/app/models/dashboard/like_unlike.dart';
import 'package:blog/app/models/response_status.dart';
import 'package:blog/app/views/dashboard/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_string.dart';
import '../../constants/colors.dart';
import '../../constants/helper_function.dart';
import '../../models/dashboard/blog_post.dart';
import '../../services/blog_post_service.dart';

class BlogPostController extends GetxController {
  final _postService = BlogPostService();
  var allPost = <BlogPost>[].obs;
  var deletedPost = <BlogPost>[].obs;

  var loadingData = false.obs;
  var getingDeteledPost = false.obs;
  var likeUnlikeLoading = false.obs;
  var deletingPost = false.obs;

  final _imagePicker = ImagePicker();
  var selectedCategory = "All Category".obs;

  String selectedCategoryId = "";
  String title = "";
  String description = "";

  String editCategoryId = "";
  String editTitle = "";
  String editDescription = "";

  var isNetworkImage = false.obs;
  String deletedThumbnail = "";
  var networkImage = <String>[].obs;
  var deletedImage = <String>[];

  var thumbnailPaths = "".obs;
  var imagesPaths = <String>[].obs;
  var creatingPost = false.obs;
  var updatingPost = false.obs;

  //var selectedCategoryId = "";
  editPost(String postId) async {
    if (!updatingPost.value) {
      updatingPost.value = true;
      if (editCategoryId.isNotEmpty) {
        if (thumbnailPaths.isNotEmpty) {
          final content = {
            "title": editTitle,
            "description": editDescription,
            "postId": postId,
            "categoryId": editCategoryId,
            "deletedThumbnail": deletedThumbnail,
          };
          if (!isNetworkImage.value) {
            imagesPaths.insert(0, thumbnailPaths.value);
          }
          final response = await _postService.editPost(content, imagesPaths, deletedImage);
          if (response.error == null) {
            final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();
            bool success = responseStatus.success ?? false;

            if (success) {
              editTitle = "";
              editDescription = "";
              editCategoryId = "";
              thumbnailPaths.value = "";
              deletedThumbnail = "";
              imagesPaths.clear();
              deletedImage.clear();
              getAllPost();
              Get.offAll(() => const DashboardView());
              updatingPost.value = false;
            } else {
              updatingPost.value = false;
              showError(error: responseStatus.message ?? "");
            }
          } else if (response.error == UN_AUTHERNTICATED) {
            updatingPost.value = false;
            logOut();
          } else {
            updatingPost.value = false;
            showError(error: response.error ?? "");
          }
        } else {
          updatingPost.value = false;
          showError(error: "select a thumbnail", title: "Thumbnail");
        }
      } else {
        updatingPost.value = false;
        showError(error: "select a category", title: "Category");
      }
    }
  }

//updatingPost

  createPost() async {
    if (!creatingPost.value) {
      creatingPost.value = true;
      if (selectedCategoryId.isNotEmpty) {
        if (thumbnailPaths.isNotEmpty) {
          final content = {
            "title": title,
            "description": description,
            "categoryId": selectedCategoryId,
          };

          imagesPaths.insert(0, thumbnailPaths.value);

          final response = await _postService.createPost(content, imagesPaths);
          if (response.error == null) {
            final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();
            bool success = responseStatus.success ?? false;

            if (success) {
              title = "";
              description = "";
              selectedCategoryId = "";
              thumbnailPaths.value = "";
              imagesPaths.clear();
              getAllPost();
              Get.back();
              creatingPost.value = false;
            } else {
              creatingPost.value = false;
              showError(error: responseStatus.message ?? "");
            }
          } else if (response.error == UN_AUTHERNTICATED) {
            creatingPost.value = false;
            logOut();
          } else {
            creatingPost.value = false;
            showError(error: response.error ?? "");
          }
        } else {
          creatingPost.value = false;
          showError(error: "select a thumbnail", title: "Thumbnail");
        }
      } else {
        creatingPost.value = false;
        showError(error: "select a category", title: "Category");
      }
    }
  }

  selectImages() async {
    var files = await _imagePicker.pickMultiImage();

    for (var item in files) {
      imagesPaths.add(item.path);
    }
  }

  selectThumnail({String? thumbnail}) async {
    var pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (isNetworkImage.value) {
        deletedThumbnail = thumbnail ?? "";
        isNetworkImage.value = false;
      }
      thumbnailPaths.value = pickedFile.path;
    } else {
      Get.snackbar(
        "Not Selected",
        "Image not Selected.",
        colorText: whiteColor,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

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

  deletePost(String postId, int index) async {
    if (!deletingPost.value) {
      deletingPost.value = true;

      final response = await _postService.deletePost(postId);

      if (response.error == null) {
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();
        bool success = responseStatus.success ?? false;
        if (success) {
          allPost.removeAt(index);
          getDeletedPost();
          deletingPost.value = false;
        } else {
          showError(error: response.error ?? "");
          deletingPost.value = false;
        }
        deletingPost.value = false;
      } else if (response.error == UN_AUTHERNTICATED) {
        logOut();
        deletingPost.value = false;
      } else {
        showError(error: response.error ?? "");
        deletingPost.value = false;
      }
    }
  }

  deletePostPermanent(String postId, int index) async {
    if (!deletingPost.value) {
      deletingPost.value = true;

      final response = await _postService.deletePostpermanent(postId);

      if (response.error == null) {
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();
        bool success = responseStatus.success ?? false;
        if (success) {
          deletedPost.removeAt(index);
          deletingPost.value = false;
        } else {
          showError(error: response.error ?? "");
          deletingPost.value = false;
        }
        deletingPost.value = false;
      } else if (response.error == UN_AUTHERNTICATED) {
        logOut();
        deletingPost.value = false;
      } else {
        showError(error: response.error ?? "");
        deletingPost.value = false;
      }
    }
  }

  getDeletedPost() async {
    var response = await _postService.getdeletedPost();
    if (response.error == null) {
      var postList = response.data != null ? response.data as List<dynamic> : [];

      deletedPost.clear();
      for (var item in postList) {
        deletedPost.add(item);
      }
    } else if (response.error == UN_AUTHERNTICATED) {
      logOut();
    }
  }

  @override
  void onInit() {
    getDeletedPost();
    getAllPost();
    super.onInit();
  }
}
