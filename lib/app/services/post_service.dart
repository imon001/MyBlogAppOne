// ignore_for_file: unused_local_variable

import 'package:blog/app/models/dashboard/like_unlike.dart';
import 'package:blog/app/models/response_status.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/api_string.dart';
import '../constants/app_string.dart';
import '../constants/helper_function.dart';
import '../models/api_response.dart';
import '../models/dashboard/blog_post.dart';

class PostService {
  Future<ApiResponse> getAllPost() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var url = Uri.parse(getAllPostApi);
      String token = await getToken();

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        // print(response.statusCode);
        var json = jsonDecode(response.body);
        //log(json.toString());
        apiResponse.data = json.map((item) => BlogPost.fromJson(item)).toList();
        apiResponse.data as List<dynamic>;
      } else {
        var json = jsonDecode(response.body);

        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }
    return apiResponse;
  }

  Future<ApiResponse> likeUnlike(String postId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var url = Uri.parse(likeUnlikeApi + postId);
      String token = await getToken();

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        // print(response.statusCode);
        var json = jsonDecode(response.body);
        final responseStatus = ResponseStatus.fromJson(json);
        responseStatus.data = LikeUnlike.fromJson(json["data"]);
        apiResponse.data = responseStatus;
      } else {
        var json = jsonDecode(response.body);

        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }
    return apiResponse;
  }
}
