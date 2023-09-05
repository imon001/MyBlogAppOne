// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:blog/app/constants/api_string.dart';
import 'package:blog/app/controllers/dashboard/blog_post_controller.dart';
import 'package:blog/app/models/dashboard/blog_post.dart';
import 'package:blog/app/models/dashboard/post_category.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../controllers/dashboard/home_controller.dart';

class EditPostView extends StatefulWidget {
  const EditPostView({super.key, required this.blogPost});

  final BlogPost blogPost;

  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final controller = Get.find<BlogPostController>();
  void setValues() {
    BlogPost blogPost = widget.blogPost;
    final category = blogPost.category != null ? blogPost.category as PostCategory : PostCategory();
    //
    //
    _titleController.text = blogPost.title ?? "";
    _descriptionController.text = blogPost.description ?? "";
    //
    //
    controller.editTitle = blogPost.title ?? "";
    controller.editDescription = blogPost.description ?? "";
    controller.editCategoryId = category.id ?? "";
    controller.selectedCategory.value = category.name ?? "";

    //thumbnaill
    controller.deletedThumbnail = "";
    controller.thumbnailPaths.value = blogPost.thumbnail ?? "";
    controller.isNetworkImage.value = true;

    //other images
    controller.networkImage.value = blogPost.images ?? [];
    controller.deletedImage = [];
  }

  @override
  void initState() {
    setValues();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Post',
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.0.w,
            vertical: 5.0.w,
          ),
          child: Form(
            key: _key,
            child: ListView(
              children: [
                Obx(() {
                  var categories = Get.find<HomeController>().categories;
                  var categoryNames = ["All Chategory"];
                  for (var item in categories) {
                    categoryNames.add(item.name ?? "");
                    //categoryNames.add(item.id ?? "");
                  }
                  return DropdownSearch(
                    popupShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    showSearchBox: true,
                    items: categoryNames,
                    selectedItem: controller.selectedCategory.value,
                    onChanged: (name) {
                      String selectedId = "";

                      for (var item in categories) {
                        if (item.name == name) {
                          selectedId = item.id ?? "";
                          break;
                        }
                      }
                      Get.find<BlogPostController>().editCategoryId = selectedId;
                    },
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0.w),
                    labelText: 'Title',
                    hintText: 'Enter Post Title',
                    hintStyle: TextStyle(
                      color: kBaseColor,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: kBaseColor,
                      width: 2.w,
                    )),
                  ),
                  controller: _titleController,
                  onSaved: (value) {
                    controller.editTitle = value ?? "";
                  },
                  validator: MultiValidator([
                    MinLengthValidator(3, errorText: 'Minimum 3 character required'),
                    RequiredValidator(errorText: 'Title is required'),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0.w),
                    labelText: 'Description',
                    hintText: 'Enter Post Description',
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(
                      color: kBaseColor,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: kBaseColor,
                      width: 2.w,
                    )),
                  ),
                  maxLines: 8,
                  controller: _descriptionController,
                  onSaved: (value) {
                    controller.editDescription = value ?? "";
                  },
                  validator: MultiValidator([
                    MinLengthValidator(3, errorText: 'Minimum 3 character required'),
                    RequiredValidator(errorText: 'Description is required'),
                  ]),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        MaterialButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                          onPressed: () {
                            Get.find<BlogPostController>().selectThumnail(thumbnail: widget.blogPost.thumbnail ?? "");
                          },
                          color: whiteBackgroundColor,
                          child: Row(
                            children: [Icon(Icons.image), SizedBox(width: 5), Text('Select Post Thumbnail')],
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      String thumbnailpath = controller.thumbnailPaths.value;
                      bool isNetworkImage = controller.isNetworkImage.value;
                      return thumbnailpath.isEmpty
                          ? Container()
                          : SizedBox(
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  isNetworkImage
                                      ? Image.network(imageBaseUrl + thumbnailpath)
                                      : Image.file(
                                          File(thumbnailpath),
                                        ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                          onPressed: () {
                                            if (isNetworkImage) {
                                              controller.deletedThumbnail = controller.thumbnailPaths.value;
                                              controller.isNetworkImage.value = false;
                                            }
                                            controller.thumbnailPaths.value = "";
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )))
                                ],
                              ),
                            );
                    })
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        MaterialButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                          onPressed: () {
                            controller.selectImages();
                          },
                          color: whiteBackgroundColor,
                          child: Row(
                            children: [Icon(Icons.image), SizedBox(width: 5), Text('Select Post Images')],
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      final imagesPath = controller.imagesPaths;
                      return imagesPath.isEmpty
                          ? Container()
                          : Wrap(
                              children: List.generate(imagesPath.length, (index) {
                                String path = imagesPath[index];
                                return Padding(
                                  padding: EdgeInsets.all(5.0.w),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Stack(
                                      children: [
                                        Image.file(File(path)),
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                                onPressed: () {
                                                  controller.imagesPaths.removeAt(index);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            );
                    }),
                    Obx(() {
                      final images = controller.networkImage;
                      return images.isEmpty
                          ? Container()
                          : Wrap(
                              children: List.generate(images.length, (index) {
                                String path = images[index];
                                return path.isEmpty
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.all(5.0.w),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Stack(
                                            children: [
                                              Image.network(imageBaseUrl + path),
                                              Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        controller.deletedImage.add(path);
                                                        controller.networkImage.removeAt(index);
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      )))
                                            ],
                                          ),
                                        ),
                                      );
                              }),
                            );
                    }),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                    color: kBaseColor,
                    height: 35.w,
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _key.currentState!.save();
                        controller.editPost(widget.blogPost.id ?? "");
                      }
                    },
                    child: Obx(() {
                      return controller.updatingPost.value
                          ? SizedBox(
                              height: 25.w,
                              width: 25.w,
                              child: LoadingIndicator(
                                indicatorType: Indicator.lineScalePulseOutRapid,
                                colors: const [Colors.white],
                                strokeWidth: 2.w,
                                backgroundColor: kBaseColor,
                                pathBackgroundColor: kBaseColor,
                              ),
                            )
                          : Text(
                              'Update',
                              style: TextStyle(fontSize: 20.sp),
                            );
                    })),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
