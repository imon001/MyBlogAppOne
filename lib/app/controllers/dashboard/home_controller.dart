// ignore_for_file: avoid_print

import 'package:get/get.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/dashboard/post_category.dart';
import '../../services/home_service.dart';

class HomeController extends GetxController {
  var categories = <PostCategory>[].obs;
  final _homeService = HomeService();

  var selectedCategoryId = "";
  var isSearching = false.obs;

  getCategories() async {
    var response = await _homeService.getCategories();
    if (response.error == null) {
      var categoryList = response.data != null ? response.data as List<dynamic> : [];
      categories.clear();
      for (var item in categoryList) {
        categories.add(item);
      }
    } else if (response.error == UN_AUTHERNTICATED) {
      logOut();
    }
  }

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }
}
