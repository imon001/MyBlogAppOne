// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/colors.dart';
import '../../../controllers/auth/forgetpass_contorller.dart';

import '../singin/singin_view.dart';
import '../singup/singup_view.dart';

class ForgetPassView extends StatefulWidget {
  const ForgetPassView({super.key});

  @override
  State<ForgetPassView> createState() => _ForgetPassViewState();
}

class _ForgetPassViewState extends State<ForgetPassView> {
  final _emailController = TextEditingController();
  final _key = GlobalKey<FormState>();
  // bool isClickedForgetPassView = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
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
              _titleZero(),
              SizedBox(
                height: 30,
              ),
              _title(),
              SizedBox(
                height: 15.w,
              ),
              _emailField(),
              SizedBox(
                height: 10.w,
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

  Widget _titleZero() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Email Verify',
          style: TextStyle(
            fontSize: 30.sp,
          ),
        ),
      ],
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'Enter your email to get otp for password recovery',
            style: TextStyle(
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emailField() {
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
        Get.find<ForgetPassController>().email = value;
      },
      validator: MultiValidator([
        EmailValidator(errorText: 'please enter a valid email'),
        RequiredValidator(errorText: 'email is required'),
      ]),
    );
  }

  Widget _submitButton() {
    final controller = Get.find<ForgetPassController>();

    return MaterialButton(
        color: kBaseColor,
        height: 35.w,
        onPressed: () {
          if (_key.currentState!.validate()) {
            controller.handleForgetPassView();
          }
        },
        child: Obx(() {
          return controller.sendingOtp.value
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
                  'Next',
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
            Get.offAll(() => SingUpView());
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
            Get.offAll(() => SingInView());
          },
          child: Text(
            'Sing in?',
            style: TextStyle(
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    );
  }
}
