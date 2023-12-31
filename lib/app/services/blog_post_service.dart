// ignore_for_file: unused_local_variable

import 'package:blog/app/models/dashboard/like_unlike.dart';
import 'package:blog/app/models/response_status.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import '../constants/api_string.dart';
import '../constants/app_string.dart';
import '../constants/helper_function.dart';
import '../models/api_response.dart';
import '../models/dashboard/blog_post.dart';

class BlogPostService {
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

  Future<ApiResponse> createPost(Map<String, dynamic> content, List<String> images) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final token = await getToken();
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse(createPostApi);

      var request = http.MultipartRequest("POST", url);

      request.headers.addAll(headers);

      for (var img in images) {
        String ext = img.split('.').last;

        var file = await http.MultipartFile.fromPath("images", img, contentType: MediaType('image', ext));
        request.files.add(file);
      }
      request.fields["title"] = content["title"];
      request.fields["description"] = content["description"];
      request.fields["categoryId"] = content["categoryId"];

      final response = await request.send();
      final responseData = await response.stream.toBytes();

      final responseString = String.fromCharCodes(responseData);
      // final responseString = String.fromCharCode(responseData);

      final json = jsonDecode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        apiResponse.data = ResponseStatus.fromJson(json);
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }

  Future<ApiResponse> editPost(Map<String, dynamic> content, List<String> images, List<String> deletedImage) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final token = await getToken();
      var headers = {
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse(editPostApi);

      var request = http.MultipartRequest("POST", url);

      request.headers.addAll(headers);

      for (var img in images) {
        String ext = img.split('.').last;

        var file = await http.MultipartFile.fromPath("images", img, contentType: MediaType('image', ext));
        request.files.add(file);
      }

      request.fields["title"] = content["title"];
      request.fields["description"] = content["description"];
      request.fields["postId"] = content["postId"];
      request.fields["categoryId"] = content["categoryId"];

      //
      //
      request.fields["deletedThumbnail"] = content["deletedThumbnail"] ?? "";
      request.fields["deletedImage"] = jsonEncode(content["deletedImage"]);

      final response = await request.send();
      final responseData = await response.stream.toBytes();

      final responseString = String.fromCharCodes(responseData);
      // final responseString = String.fromCharCode(responseData);

      final json = jsonDecode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        apiResponse.data = ResponseStatus.fromJson(json);
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }

  Future<ApiResponse> deletePost(String postId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var url = Uri.parse(deletePostApi + postId);
      String token = await getToken();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.delete(url, headers: headers);
      var json = jsonDecode(response.body);
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

  Future<ApiResponse> deletePostpermanent(String postId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var url = Uri.parse(deletePostPermanentApi + postId);
      String token = await getToken();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.delete(url, headers: headers);
      var json = jsonDecode(response.body);
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

  Future<ApiResponse> getdeletedPost() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var url = Uri.parse(getdeletedPostApi);
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

  Future<ApiResponse> savePost(String postId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var url = Uri.parse(savePostApi + postId);
      String token = await getToken();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.get(url, headers: headers);
      var json = jsonDecode(response.body);
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

  Future<ApiResponse> getSavedPost() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var url = Uri.parse(getSavedPostApi);
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

  Future<ApiResponse> removeSavedPost(String postId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var url = Uri.parse(removedSavedPostApi + postId);
      String token = await getToken();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.delete(url, headers: headers);
      var json = jsonDecode(response.body);
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

  Future<ApiResponse> restorePost(String postId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var url = Uri.parse(restorePostApi + postId);
      String token = await getToken();
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.get(url, headers: headers);
      var json = jsonDecode(response.body);
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

  Future<ApiResponse> getPostBycategory(String categoryId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var url = Uri.parse(getCategoryPostApi + categoryId);
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

  Future<ApiResponse> searchPost(String keyword) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      var url = Uri.parse(searchOptionApi + keyword);
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
}
