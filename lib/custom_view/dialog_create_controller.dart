import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogCreateController extends GetxController {
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final timeSelected = const TimeOfDay(hour: 0, minute: 0).obs;

  String get title => titleController.text;
  String get detail => detailController.text;

  @override
  void onClose() {
    titleController.dispose();
    detailController.dispose();
    super.onClose();
  }
}