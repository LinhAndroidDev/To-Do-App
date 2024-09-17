import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/color_name.dart';

import 'custom_search_controller.dart';

class CustomSearchView extends StatelessWidget {
  CustomSearchView({
    super.key,
    required this.keySearch
  });

  final ValueChanged<String> keySearch;

  final controller = Get.put(CustomSearchController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: ColorName.grey,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller.textController,
        style: const TextStyle(fontSize: 14, color: ColorName.black),
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: ColorName.greyDark),
          suffixIcon: Obx(() => controller.keySearch.value.isNotEmpty
              ? InkWell(
            onTap: () {
              controller.clearSearch();
              keySearch('');
            },
              child: const Icon(Icons.clear, color: ColorName.greyDark))
            : const Icon(Icons.circle, color: ColorName.grey,),),
          suffixIconConstraints: const BoxConstraints(maxHeight: 20),
          border: InputBorder.none,
          isDense: true,
          hintText: 'Tìm kiếm...',
          hintStyle: const TextStyle(fontSize: 14, color: ColorName.greyDark),
        ),onChanged: (value) {
          controller.updateKeySearch(value);
          keySearch(value ?? '');
        },
      ),
    );
  }
}
