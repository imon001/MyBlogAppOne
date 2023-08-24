// ignore_for_file: unused_field, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/colors.dart';

import '../../../controllers/auth/forgetpass_contorller.dart';
import '../../../controllers/auth/singin_controller.dart';
import '../../../controllers/auth/singup_controller.dart';
import '../forget_pass/forget_pass_view.dart';
import '../singup/singup_view.dart';

class SingInView extends StatefulWidget {
  const SingInView({super.key});

  @override
  State<SingInView> createState() => _SingInViewState();
}

class _SingInViewState extends State<SingInView> {
  final _singUpController = Get.put(SingUpController());
  final _singInController = Get.put(SingInController());
  final _forgetPassController = Get.put(ForgetPassController());

  final _emailController = TextEditingController();
  final _passwprdController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
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
              _emailField(),
              SizedBox(
                height: 10.w,
              ),
              _passField(),
              SizedBox(
                height: 15.w,
              ),
              _submitButton(),
              _downNavs()
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
          'Sing in',
          style: TextStyle(
            fontSize: 30.sp,
          ),
        ),
      ],
    );
  }

  Widget _emailField() {
    final controller = Get.find<SingInController>();

    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8.0.w),
        labelText: 'Email',
        labelStyle: TextStyle(color: kBaseColor, fontSize: 18.sp),
        hintText: 'Enter your email',
        hintStyle: TextStyle(
          color: kBaseColor,
        ),
        prefixIcon: Icon(
          Icons.email,
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
      controller: _emailController,
      onChanged: (value) {
        controller.email = value;
      },
      validator: MultiValidator([
        EmailValidator(errorText: 'please enter a valid email'),
        RequiredValidator(errorText: 'email is required'),
      ]),
    );
  }

  Widget _passField() {
    return Obx(() {
      final controller = Get.find<SingInController>();

      return TextFormField(
        obscureText: controller.isPasH.value ? true : false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8.0.w),
          labelText: 'Password',
          labelStyle: TextStyle(color: kBaseColor, fontSize: 18.sp),
          hintText: 'Enter your Password',
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
          controller.password = value;
        },
        validator: MultiValidator([
          MinLengthValidator(6, errorText: 'minimum 6 character required'),
          RequiredValidator(errorText: 'password is required'),
        ]),
      );
    });
  }

  Widget _submitButton() {
    final controller = Get.find<SingInController>();
    return MaterialButton(
        color: kBaseColor,
        height: 35.w,
        onPressed: () {
          if (_key.currentState!.validate()) {
            controller.handleSingInView();
          }
        },
        child: Obx(() {
          return controller.isClickedSingInView.value
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
                  'Sing In',
                  style: TextStyle(fontSize: 20.sp),
                );
        }));
  }

  Widget _downNavs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => SingUpView());
          },
          child: Text(
            'Sing Up?',
            style: TextStyle(
              fontSize: 18.sp,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => ForgetPassView());
          },
          child: Text(
            'Forget Password?',
            style: TextStyle(
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    );
  }
}
