// ignore_for_file: prefer_const_constructors

import 'package:blog/app/controllers/dashboard/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/colors.dart';
import '../../../models/auth/user.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.user});

  final User user;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  User user = User();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _shortBioController = TextEditingController();

  final _key = GlobalKey<FormState>();

  setValue() {
    user = widget.user;

    final controller = Get.find<ProfileController>();

    //
    _nameController.text = user.name ?? "";
    _phoneController.text = user.phone ?? "";
    _shortBioController.text = user.shortBio ?? "";

    //
    //
    controller.name = user.name ?? "";
    controller.phone = user.phone ?? "";
    controller.shortBio = user.shortBio ?? "";
  }

  @override
  void initState() {
    setValue();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _shortBioController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        elevation: 5,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.0.w),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              SizedBox(
                height: 10.w,
              ),
              _nameField(),
              SizedBox(
                height: 10.w,
              ),
              _phoneField(),
              SizedBox(
                height: 10.w,
              ),
              _shortBioField(),
              SizedBox(
                height: 10.w,
              ),
              _updateButton()
            ],
          ),
        ),
      )),
    );
  }

  Widget _nameField() {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8.0.w),
        labelText: 'Full Name',
        labelStyle: TextStyle(color: kBaseColor, fontSize: 18.sp),
        hintText: 'Enter your full name',
        hintStyle: TextStyle(
          color: kBaseColor,
        ),
        prefixIcon: Icon(
          Icons.person,
          color: kBaseColor,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: kBaseColor,
          width: 2.w,
        )),
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: kBaseColor,
          width: 2.w,
        )),
      ),
      controller: _nameController,
      onSaved: (value) {
        Get.find<ProfileController>().name = value ?? "";
      },
      validator: MultiValidator([
        MinLengthValidator(3, errorText: 'Minimum 3 character required'),
        RequiredValidator(errorText: 'Name is required'),
      ]),
    );
  }

  Widget _phoneField() {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8.0.w),
        labelText: 'Phone Number',
        labelStyle: TextStyle(color: kBaseColor, fontSize: 18.sp),
        hintText: 'Enter your phone number',
        hintStyle: TextStyle(
          color: kBaseColor,
        ),
        prefixIcon: Icon(
          Icons.phone,
          color: kBaseColor,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: kBaseColor,
          width: 2.w,
        )),
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: kBaseColor,
          width: 2.w,
        )),
      ),
      controller: _phoneController,
      onSaved: (value) {
        Get.find<ProfileController>().phone = value ?? "";
      },
      validator: MultiValidator([
        MinLengthValidator(3, errorText: 'Minimum 11 character required'),
        RequiredValidator(errorText: 'Phone number is required'),
      ]),
    );
  }

  Widget _shortBioField() {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8.0.w),
        labelText: 'Short Bio',
        labelStyle: TextStyle(color: kBaseColor, fontSize: 18.sp),
        hintText: 'Enter your short bio',
        hintStyle: TextStyle(
          color: kBaseColor,
        ),
        prefixIcon: Icon(
          Icons.details,
          color: kBaseColor,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: kBaseColor,
          width: 2.w,
        )),
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: kBaseColor,
          width: 2.w,
        )),
      ),
      controller: _shortBioController,
      onSaved: (value) {
        Get.find<ProfileController>().shortBio = value ?? "";
      },
      validator: MultiValidator([
        MinLengthValidator(3, errorText: 'Minimum 6 character required'),
        RequiredValidator(errorText: 'Short bio is required'),
      ]),
    );
  }

  Widget _updateButton() {
    return MaterialButton(
        minWidth: double.infinity,
        color: kBaseColor,
        onPressed: () {
          if (_key.currentState!.validate()) {
            _key.currentState!.save();
            Get.find<ProfileController>().updateProfile();
          }
        },
        child: Obx(() {
          final controller = Get.find<ProfileController>();
          return controller.updatingProfile.value
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
        }));
  }
}
