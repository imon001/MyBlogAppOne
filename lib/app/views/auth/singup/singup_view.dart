// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/colors.dart';
import '../../../controllers/auth/singup_controller.dart';
import '../forget_pass/forget_pass_view.dart';
import '../singin/singin_view.dart';

class SingUpView extends StatefulWidget {
  const SingUpView({super.key});

  @override
  State<SingUpView> createState() => _SingUpViewState();
}

class _SingUpViewState extends State<SingUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();

  // handleSingUpView() {
  //   if (!isClickedSingUpView) {
  //     setState(() {
  //       isClickedSingUpView = true;
  //     });
  //     Future.delayed(Duration(milliseconds: 300)).then((value) {
  //       Get.to(() => SingUpOtpView());
  //       setState(() {
  //         isClickedSingUpView = false;
  //       });
  //     });
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
              _nameField(),
              SizedBox(
                height: 10.w,
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
          'Create New Account',
          style: TextStyle(
            fontSize: 30.sp,
          ),
        ),
      ],
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
      onChanged: (value) {
        Get.find<SingUpController>().name = value;
      },
      validator: MultiValidator([
        MinLengthValidator(3, errorText: 'Minimum 3 character required'),
        RequiredValidator(errorText: 'Name is required'),
      ]),
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
        Get.find<SingUpController>().email = value;
      },
      validator: MultiValidator([
        EmailValidator(errorText: 'please enter a valid email'),
        RequiredValidator(errorText: 'email is required'),
      ]),
    );
  }

  Widget _passField() {
    return Obx(() {
      final controller = Get.find<SingUpController>();

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
        controller: _passwordController,
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
    final controller = Get.find<SingUpController>();
    return MaterialButton(
        color: kBaseColor,
        height: 35.w,
        onPressed: () {
          if (_key.currentState!.validate()) {
            controller.handleSendOtp();
            //handleSingUpView();
          }
        },
        child: Obx(() {
          return controller.isClickedSendOtp.value //isClickedSingUpView//
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
            Get.to(() => SingInView());
          },
          child: Text(
            'Back To Sing In?',
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
