// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:blog/app/models/response_status.dart';
import 'package:http/http.dart' as http;

import '../constants/api_string.dart';
import '../constants/app_string.dart';
import '../constants/helper_function.dart';
import '../models/api_response.dart';
import '../models/auth/user.dart';
//
//
//
//
//
//
//
//
//
//
//

class AuthService {
  //singIp auth
  Future<ApiResponse> singIn({required String body}) async {
    var url = Uri.parse(loginApi);

    ApiResponse apiResponse = ApiResponse();

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(url, body: body, headers: headers);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        apiResponse.data = User.fromJson(json);
      } else {
        var json = jsonDecode(response.body);

        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      // print(e.toString());
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }

// /////////////////////////////////////////////////////////////////////////////////////////
//
//
//singUp auth
  Future<ApiResponse> singUp({required String body}) async {
    var url = Uri.parse(registerApi);

    ApiResponse apiResponse = ApiResponse();

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body);
        apiResponse.data = User.fromJson(json);
      } else {
        var json = jsonDecode(response.body);
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////

//checkResetPass

  Future<ApiResponse> checkResetPass({required String body}) async {
    var url = Uri.parse(checkResetPassApi);

    ApiResponse apiResponse = ApiResponse();

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        apiResponse.data = ResponseStatus.fromJson(json);
      } else {
        var json = jsonDecode(response.body);
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////
  ///reserPassword
  Future<ApiResponse> resetPass({required String body}) async {
    var url = Uri.parse(resetPassApi);

    ApiResponse apiResponse = ApiResponse();

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.put(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        apiResponse.data = ResponseStatus.fromJson(json);
      } else {
        var json = jsonDecode(response.body);
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////
//
  Future<ApiResponse> updatePass({required String body}) async {
    var url = Uri.parse(updatePasswordApi);

    ApiResponse apiResponse = ApiResponse();
    String token = await getToken();

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.put(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        apiResponse.data = ResponseStatus.fromJson(json);
      } else {
        var json = jsonDecode(response.body);
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }
//
}
