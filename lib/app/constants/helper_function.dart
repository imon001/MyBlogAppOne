// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../views/splash/splash_screen.dart';
import 'app_string.dart';
import 'colors.dart';

final _storage = GetStorage();
final _secureStorage = FlutterSecureStorage();
//
//
//
//
//
//
Future<String> getToken() async {
  var token = await _secureStorage.read(key: AUTH_TOKEN) ?? "";
  return token;
}

//
//
//
//
//
//
void showError({required error, String? title}) {
  Get.defaultDialog(
      title: title ?? "Opps!",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            error,
            style: TextStyle(
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5.w,
          ),
          MaterialButton(
            color: kBaseColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                5.r,
              ),
            ),
            onPressed: () => Get.back(),
            child: Text(
              "Ok",
              style: TextStyle(fontSize: 18.sp),
            ),
          )
        ],
      ));
}

//
//
//
void showCustomDialog({required String message, required String title}) {
  Get.defaultDialog(
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5.w,
          ),
          MaterialButton(
            color: kBaseColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                5.r,
              ),
            ),
            onPressed: () => Get.back(),
            child: Text(
              "Ok",
              style: TextStyle(fontSize: 18.sp),
            ),
          )
        ],
      ));
}
//
//
//
//
//

Future<void> logOut() async {
  await _storage.remove(IS_LOGGED_IN);
  await _storage.remove(USER_NAME);
  await _storage.remove(USER_EMAIL);
  await _storage.remove(USER_AVATAR);
  await _storage.remove(USER_ID);

  _secureStorage.delete(key: AUTH_TOKEN);

  Get.offAll(() => SplashScreen());
}

//
handleError(int statusCode, json) {
  // log(json.toString());
  switch (statusCode) {
    case 400:
      String msg = json['message'] ?? "";
      String error = json['errors'] != null ? json['errors'][0]['msg'] ?? "" : "";

      return msg.isNotEmpty ? msg : error;

    case 401:
      return UN_AUTHERNTICATED;

    case 422:
      final errors = json['errors'];
      return errors[errors.keys.elementAt(0)][0];

    case 403:
      return json['message'];

    case 500:
      return SERVER_ERROR;

    default:
      return SOMETHING_WENT_WRONG;
  }
}

getCustomeDate(String date) {
  if (date.isEmpty) {
    return "";
  }

  DateTime time = DateTime.parse(date);
  int day = time.day;
  int month = time.month;
  int year = time.year;
  String newDay = day < 10 ? '0$day' : '$day';
  String newMonth = month < 10 ? '0$month' : '$month';

  String newDate = '$newDay-$newMonth-$year';

  return newDate;
}

String get userId {
  return _storage.read(USER_ID) ?? "";
}

getTimeAgo(String time) {
  if (time.isEmpty) {
    return '';
  } else {
    DateTime dbDate = DateTime.parse(time);
    final currDate = DateTime.now();

    var difference = currDate.difference(dbDate).inMinutes;

    if (difference < 1) {
      return "Just Now";
    } else if (difference < 60) {
      return "$difference min ago";
    } else if (difference < 1440) {
      return "${(difference / 60).toStringAsFixed(0)} hr ago";
    } else if (difference < 43200) {
      return "${(difference / 1440).toStringAsFixed(0)} days ago";
    } else if (difference < 518400) {
      return "${(difference / 43200).toStringAsFixed(0)} Months ago";
    }
  }
}
