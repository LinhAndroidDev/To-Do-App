import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomSearchController extends GetxController {
  var textController = TextEditingController();
  var keySearch = ''.obs;

  void clearSearch() {
    textController.text = '';
    keySearch.value = '';
  }

  void updateKeySearch(String value) {
    keySearch.value = value ?? '';
  }
}