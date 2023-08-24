import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/helper_function.dart';
import '../../models/response_status.dart';
import '../../services/auth_service.dart';
import '../../views/auth/new_pass/new_pass_view.dart';
import '../../views/auth/otp/forget_pass_otp/forget_pass_otp.dart';
import '../../views/splash/splash_screen.dart';

class ForgetPassController extends GetxController {
  final _authService = AuthService();
  var sendingOtp = false.obs;
  var isClickedForgetPassOtpView = false.obs;
  var isClickedNewPassView = false.obs;
  var isPasH = true.obs;

  String email = '';
  String newPass = '';

  handleForgetPassView() async {
    if (!sendingOtp.value) {
      sendingOtp.value = true;

      String body = jsonEncode({
        "email": email.trim(),
      });

      await _authService.checkResetPass(body: body).then((response) {
        if (response.error == null) {
          var resStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();
          bool success = resStatus.success ?? false;
          if (success) {
            Get.to(() => const ForgetPassOtpView());
          } else {
            showError(error: resStatus.message ?? "");

            sendingOtp.value = false;
          }
        } else {
          showError(error: response.error ?? "");

          sendingOtp.value = false;
        }
      });
    }
  }

  sendOtp() {
    if (!isClickedForgetPassOtpView.value) {
      isClickedForgetPassOtpView.value = true;
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        Get.to(() => const NewPassView());
        isClickedForgetPassOtpView.value = false;
      });
    }
  }

  handleNewPassView() async {
    if (!isClickedNewPassView.value) {
      isClickedNewPassView.value = true;

      var body = jsonEncode({
        "email": email.trim(),
        "newPass": newPass.trim(),
      });

      await _authService
          .resetPass(
        body: body,
      )
          .then((response) {
        if (response.error == null) {
          var resStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();
          bool success = resStatus.success ?? false;
          if (success) {
            Get.snackbar(
              "Done",
              resStatus.message ?? "",
              colorText: whiteColor,
              backgroundColor: Colors.black54,
              snackPosition: SnackPosition.BOTTOM,
            );

            Get.offAll(() => const SplashScreen());
          } else {
            showError(error: resStatus.message ?? "");
            isClickedNewPassView.value = false;
          }
        } else {
          showError(error: response.error ?? "");
          isClickedNewPassView.value = false;
        }
      });
    }
  }
}
