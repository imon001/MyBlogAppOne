// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:blog/app/controllers/dashboard/blog_post_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../controllers/dashboard/home_controller.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final controller = Get.find<BlogPostController>();

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
          'New Post',
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
                    selectedItem: "All Category",
                    onChanged: (name) {
                      String selectedId = "";

                      for (var item in categories) {
                        if (item.name == name) {
                          selectedId = item.id ?? "";
                          break;
                        }
                      }
                      Get.find<BlogPostController>().selectedCategoryId = selectedId;
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
                    Get.find<BlogPostController>().title = value ?? "";
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
                    Get.find<BlogPostController>().description = value ?? "";
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
                            Get.find<BlogPostController>().selectThumnail();
                          },
                          color: whiteBackgroundColor,
                          child: Row(
                            children: [Icon(Icons.image), SizedBox(width: 5), Text('Select Post Thumbnail')],
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      String thumbnailpath = Get.find<BlogPostController>().thumbnailPaths.value;
                      return thumbnailpath.isEmpty
                          ? Container()
                          : SizedBox(
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Image.file(File(thumbnailpath)),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                          onPressed: () {
                                            Get.find<BlogPostController>().thumbnailPaths.value = "";
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
                            Get.find<BlogPostController>().selectImages();
                          },
                          color: whiteBackgroundColor,
                          child: Row(
                            children: [Icon(Icons.image), SizedBox(width: 5), Text('Select Post Images')],
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      final images = Get.find<BlogPostController>().imagesPaths;
                      return images.isEmpty
                          ? Container()
                          : Wrap(
                              children: List.generate(images.length, (index) {
                                String path = images[index];
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
                                                  Get.find<BlogPostController>().imagesPaths.removeAt(index);
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
                    })
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
                        controller.createPost();
                      }
                    },
                    child: Obx(() {
                      return controller.creatingPost.value
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
                              'Post',
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
