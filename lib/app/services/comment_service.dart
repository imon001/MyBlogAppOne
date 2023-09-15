import 'dart:convert';

import 'package:blog/app/models/dashboard/comment_response.dart';
import 'package:blog/app/models/dashboard/reply.dart';
import 'package:blog/app/models/dashboard/reply_response.dart';
import 'package:blog/app/models/response_status.dart';
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

  Future<ApiResponse> createComments(String body) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      var url = Uri.parse(createCommentApi);
      var token = await getToken();
      var headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.post(url, headers: headers, body: body);
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final responseStatus = ResponseStatus.fromJson(json);
        responseStatus.data = CommentResponse.fromJson(json["data"]);
        apiResponse.data = responseStatus;
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }

  Future<ApiResponse> deleteComments(String commentId) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      var url = Uri.parse(deleteCommentApi + commentId);
      var token = await getToken();
      var headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.delete(
        url,
        headers: headers,
      );
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        apiResponse.data = ResponseStatus.fromJson(json);
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }

  Future<ApiResponse> getReplies(String commentId) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      var url = Uri.parse(getReplyApi + commentId);
      var token = await getToken();
      var headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.get(url, headers: headers);
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        apiResponse.data = json.map((item) => Reply.fromJson(item)).toList();
        apiResponse.data as List<dynamic>;
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }

  Future<ApiResponse> deleteReplies(String replyId) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      var url = Uri.parse(deleteReplyApi + replyId);
      var token = await getToken();
      var headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.delete(
        url,
        headers: headers,
      );
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        apiResponse.data = ResponseStatus.fromJson(json);
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }

  Future<ApiResponse> createReply(String body) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      var url = Uri.parse(createReplyApi);
      var token = await getToken();
      var headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.post(url, headers: headers, body: body);
      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final responseStatus = ResponseStatus.fromJson(json);
        responseStatus.data = ReplyResponse.fromJson(json["data"]);
        apiResponse.data = responseStatus;
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }
}
