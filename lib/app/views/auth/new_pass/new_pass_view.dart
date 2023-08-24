// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/colors.dart';
import '../../../controllers/auth/forgetpass_contorller.dart';

class NewPassView extends StatefulWidget {
  const NewPassView({
    super.key,
  });

  @override
  State<NewPassView> createState() => _NewPassViewState();
}

class _NewPassViewState extends State<NewPassView> {
  final _passwprdController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _passwprdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              SizedBox(
                height: 80.w,
              ),
              _logo(),
              SizedBox(
                height: 5,
              ),
              _title(),
              SizedBox(
                height: 30.w,
              ),
              _passField(),
              SizedBox(
                height: 15.w,
              ),
              _submitButton(),
            ],
          ),
        ),
      )),
    );
  }

  Widget _logo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 90.w,
        ),
      ],
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Enter New Password',
          style: TextStyle(
            fontSize: 30.sp,
          ),
        ),
      ],
    );
  }

  Widget _passField() {
    return Obx(() {
      final controller = Get.find<ForgetPassController>();

      return TextFormField(
        obscureText: controller.isPasH.value ? true : false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8.0.w),
          labelText: 'Password',
          labelStyle: TextStyle(color: kBaseColor, fontSize: 18.sp),
          hintText: 'Enter new Password',
          hintStyle: TextStyle(color: kBaseColor),
          suffixIcon: IconButton(
            onPressed: () {
              controller.isPasH.value = !controller.isPasH.value;
            },
            icon: controller.isPasH.value ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
          ),
          prefixIcon: Icon(
            Icons.lock,
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
        controller: _passwprdController,
        onChanged: (value) {
          controller.newPass = value;
        },
        validator: MultiValidator([
          MinLengthValidator(6, errorText: 'minimum 6 character required'),
          RequiredValidator(errorText: 'password is required'),
        ]),
      );
    });
  }

  Widget _submitButton() {
    final controller = Get.find<ForgetPassController>();
    return MaterialButton(
        color: kBaseColor,
        height: 35.w,
        onPressed: () {
          if (_key.currentState!.validate()) {
            controller.handleNewPassView();
          }
        },
        child: Obx(() {
          return controller.isClickedNewPassView.value
              ? SizedBox(
                  height: 25.w,
                  width: 25.w,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineScalePulseOutRapid,

                    /// Required, The loading type of the widget
                    colors: const [Colors.white],

                    /// Optional, The color collections
                    strokeWidth: 2.w,

                    /// Optional, The stroke of the line, only applicable to widget which contains line
                    backgroundColor: kBaseColor,

                    /// Optional, Background of the widget
                    pathBackgroundColor: kBaseColor,

                    /// Optional, the stroke backgroundColor
                  ),
                )
              : Text(
                  'Update',
                  style: TextStyle(fontSize: 20.sp),
                );
        }));
  }
}
