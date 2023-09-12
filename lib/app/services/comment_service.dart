import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_string.dart';
import '../constants/app_string.dart';
import '../constants/helper_function.dart';
import '../models/api_response.dart';
import '../models/dashboard/comment.dart';

class CommentService {
  Future<ApiResponse> getComments(String postId) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      var url = Uri.parse(getCommentApi + postId);
      var token = await getToken();
      var headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.get(url, headers: headers);
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        apiResponse.data = json.map((item) => Comment.fromJson(item)).toList();
        apiResponse.data as List<dynamic>;
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }
}
