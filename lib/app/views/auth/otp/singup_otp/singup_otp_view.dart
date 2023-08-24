// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../controllers/auth/singup_controller.dart';
import '../../singin/singin_view.dart';

class SingUpOtpView extends StatefulWidget {
  const SingUpOtpView({
    super.key,
  });

  @override
  State<SingUpOtpView> createState() => _SingUpOtpViewState();
}

class _SingUpOtpViewState extends State<SingUpOtpView> {
  final _key = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
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
                height: 10.w,
              ),
              _otpField(),
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
          'Verify OTP',
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
            'Enter six digit otp code below sent at your email',
            style: TextStyle(
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _otpField() {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8.0.w),
        labelText: 'OTP',
        labelStyle: TextStyle(color: kBaseColor, fontSize: 18.sp),
        hintStyle: TextStyle(
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
      controller: _otpController,
      validator: MultiValidator([
        RequiredValidator(errorText: 'otp is required'),
        MinLengthValidator(6, errorText: 'Minimum 6 character otp'),
      ]),
    );
  }

  Widget _submitButton() {
    final controller = Get.find<SingUpController>();
    return MaterialButton(
        color: kBaseColor,
        height: 35.w,
        onPressed: () {
          if (_key.currentState!.validate()) {
            controller.handleSingUpOtpView();
          }
        },
        child: Obx(() {
          return controller.isClickedSingUpOtpView.value
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
                  'Verify',
                  style: TextStyle(fontSize: 20.sp),
                );
        }));
  }

  Widget _downNavs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => SingInView());
          },
          child: Text(
            'Already have account?then sing in',
            style: TextStyle(
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    );
  }
}
