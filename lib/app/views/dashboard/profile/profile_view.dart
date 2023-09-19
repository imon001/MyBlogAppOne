// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, no_leading_underscores_for_local_identifiers

import 'package:blog/app/constants/api_string.dart';
import 'package:blog/app/constants/colors.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/controllers/dashboard/profile_controller.dart';
import 'package:blog/app/views/dashboard/post/deleted_posts/deleted_post_view.dart';
import 'package:blog/app/views/dashboard/post/my_post/my_post_view.dart';
import 'package:blog/app/views/dashboard/profile/edit_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/app_string.dart';
import '../post/saved_posts/saved_post_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _key = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        elevation: 5,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 8.w,
          ),
          child: ListView(
            children: [
              SizedBox(
                height: 10.w,
              ),
              _profileImage(),
              SizedBox(
                height: 10.w,
              ),
              _infoCard(),
              SizedBox(
                height: 5.w,
              ),
              _changePassword(),
              SizedBox(
                height: 5.w,
              ),
              _myPosts(),
              SizedBox(
                height: 5.w,
              ),
              _savePosts(),
              SizedBox(
                height: 5.w,
              ),
              _deletedPosts(),
              SizedBox(
                height: 5.w,
              ),
              _logOut(),
              SizedBox(
                height: 30.w,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _myPosts() {
    return _ProfileItemCard(
      prefixIcon: Icons.notes,
      text: 'My Posts',
      suffixIcon: Icons.arrow_right,
      ontap: () {
        Get.to(() => MyPostView());
      },
    );
  }

  Widget _savePosts() {
    return _ProfileItemCard(
      prefixIcon: Icons.notes,
      text: 'Saved Posts',
      suffixIcon: Icons.arrow_right,
      ontap: () {
        Get.to(() => SavePostView());
      },
    );
  }

  Widget _deletedPosts() {
    return _ProfileItemCard(
      prefixIcon: Icons.notes,
      text: 'Deleted Posts',
      suffixIcon: Icons.arrow_right,
      ontap: () {
        Get.to(() => DeletedPostView());
      },
    );
  }

  Widget _logOut() {
    return _ProfileItemCard(
      prefixIcon: Icons.logout,
      text: 'Logout',
      ontap: () {
        logOut();
      },
    );
  }

  Widget _changePassword() {
    return GestureDetector(
      onTap: () {
        final controller = Get.find<ProfileController>();
        controller.showPasswordCard.value = !controller.showPasswordCard.value;
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(10.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.lock),
                      Text(
                        "change password",
                        style: TextStyle(
                          fontSize: 18.sp,
                        ),
                      )
                    ],
                  ),
                ),
                Obx(() {
                  bool showPasswordCard = Get.find<ProfileController>().showPasswordCard.value;

                  return showPasswordCard
                      ? Icon(
                          Icons.arrow_drop_down,
                          size: 30.sp,
                        )
                      : Icon(
                          Icons.arrow_right,
                          size: 30.sp,
                        );
                })
              ]),
              SizedBox(
                height: 5.w,
              ),
              Obx(() {
                bool showPasswordCard = Get.find<ProfileController>().showPasswordCard.value;
                return showPasswordCard
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                        child: Form(
                          key: _key,
                          child: Column(
                            children: [
                              TextFormField(
                                style: TextStyle(fontSize: 16.sp),
                                decoration: InputDecoration(
                                  labelText: "Current Password",
                                ),
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(errorText: "Current assword is required"),
                                    MinLengthValidator(6, errorText: "Minimum 6 character required"),
                                  ],
                                ),
                                controller: _currentPasswordController,
                                onSaved: (value) {
                                  Get.find<ProfileController>().currentPass = value ?? "";
                                },
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: 16.sp),
                                decoration: InputDecoration(
                                  labelText: "New Password",
                                ),
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(errorText: "New password is required"),
                                    MinLengthValidator(6, errorText: "Minimum 6 character required"),
                                  ],
                                ),
                                controller: _newPasswordController,
                                onSaved: (value) {
                                  Get.find<ProfileController>().newPass = value ?? "";
                                },
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                              MaterialButton(
                                  minWidth: double.infinity,
                                  color: kBaseColor,
                                  onPressed: () async {
                                    if (_key.currentState!.validate()) {
                                      _key.currentState!.save();
                                      bool changed = await Get.find<ProfileController>().updatePassword();
                                      if (changed) {
                                        _currentPasswordController.clear();
                                        _newPasswordController.clear();
                                      }
                                    }
                                  },
                                  child: Obx(() {
                                    final controller = Get.find<ProfileController>();
                                    return controller.changingPassword.value
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
                                  }))
                            ],
                          ),
                        ),
                      )
                    : Container();
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Card(
      elevation: 3,
      child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Obx(() {
            final user = Get.find<ProfileController>().user.value;

            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.name ?? "",
                          style: TextStyle(
                            fontSize: 18,
                            color: kBaseColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Get.to(() => EditProfileView(
                                  user: user,
                                ));
                          },
                          icon: Icon(Icons.edit_note, size: 30.sp))
                    ],
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  Text(
                    "Email: ${user.email ?? "N/A"}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Phone: ${user.phone ?? "N/A"}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Total Post: ${user.postCount ?? "N/A"}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Joining Date: ${getCustomeDate(user.createdAt ?? "") ?? "N/A"}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Short Bio: ${user.shortBio ?? "N/A"}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }

  Widget _profileImage() {
    return GestureDetector(onTap: () {
      _selectProfilePhotoOption();
    }, child: Obx(() {
      var avatar = Get.find<ProfileController>().avatar.value;

      String avatarLink = imageBaseUrl + avatar;

      return Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            width: 1.w,
            color: Colors.grey.shade100,
          ),
          image: DecorationImage(
            image: avatar.isNotEmpty ? NetworkImage(avatarLink) : AssetImage(DEFAULT_AVATAR) as ImageProvider<Object>,
          ),
        ),
        child: Obx(() {
          final controller = Get.find<ProfileController>();

          return controller.updatingProfilePhoto.value ? Center(child: CircularProgressIndicator()) : Container();
        }),
      );
    }));
  }

  void _selectProfilePhotoOption() {
    Get.defaultDialog(
        title: "Select Option",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Get.find<ProfileController>().selectProfilePhoto(source: ImageSource.camera);
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    'Camera',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.w,
            ),
            GestureDetector(
              onTap: () {
                Get.find<ProfileController>().selectProfilePhoto(source: ImageSource.gallery);
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera_front_sharp),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    'Gallery',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class _ProfileItemCard extends StatelessWidget {
  const _ProfileItemCard({
    super.key,
    required this.prefixIcon,
    required this.text,
    this.suffixIcon,
    required this.ontap,
  });
  final IconData prefixIcon;
  final String text;
  final IconData? suffixIcon;
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(10.0.w),
          child: Row(children: [
            Expanded(
              child: Row(
                children: [
                  Icon(prefixIcon),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18.sp,
                    ),
                  )
                ],
              ),
            ),
            if (suffixIcon != null)
              Icon(
                suffixIcon,
                size: 30.sp,
              ),
          ]),
        ),
      ),
    );
  }
}
