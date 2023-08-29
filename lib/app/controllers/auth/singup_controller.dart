// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/auth/user.dart';
import '../../services/auth_service.dart';
import '../../views/auth/otp/singup_otp/singup_otp_view.dart';
import '../../views/dashboard/dashboard/dashboard_view.dart';

class SingUpController extends GetxController {
  final _secureStorage = FlutterSecureStorage();
  final _storage = GetStorage();
  final _authService = AuthService();

  var isPasH = true.obs;
  var isClickedSendOtp = false.obs;
  var isClickedSingUpOtpView = false.obs;

  String name = '';
  String email = '';
  String password = '';

  handleSendOtp() {
    if (!isClickedSendOtp.value) {
      isClickedSendOtp.value = true;
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        Get.to(() => const SingUpOtpView(
            // name: name.trim(),
            // email: email.trim(),
            // password: password.trim(),
            ));

        isClickedSendOtp.value = false;
      });
    }
  }

  handleSingUpOtpView() async {
    if (!isClickedSingUpOtpView.value) {
      isClickedSingUpOtpView.value = true;

      String body = jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      });
      await _authService
          .singUp(
        body: body,
      )
          .then((response) async {
        if (response.error == null) {
          User user = response.data != null ? response.data as User : User();
          _storage.write(IS_LOGGED_IN, true);
          _storage.write(USER_NAME, user.name);
          _storage.write(USER_EMAIL, user.email);
          _storage.write(USER_ID, user.id);

          await _secureStorage.write(key: AUTH_TOKEN, value: user.token);
          Get.offAll(() => const DashboardView());
        } else {
          showError(error: response.error ?? "");
        }
      });
      isClickedSingUpOtpView.value = true;
    }
  }
}
