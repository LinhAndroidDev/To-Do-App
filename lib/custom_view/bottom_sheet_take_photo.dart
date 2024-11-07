import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetTakePhoto extends StatelessWidget {
  const BottomSheetTakePhoto({
    super.key,
    required this.onPickGallery,
  });

  final ValueChanged<bool> onPickGallery;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              Get.back();
              onPickGallery(true);
            },
            child: const SizedBox(
                width: double.infinity,
                child: Text('Chọn ảnh từ Gallery',
                    style: TextStyle(fontSize: 16, color: Colors.black))),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              Get.back();
              onPickGallery(false);
            },
            child: const SizedBox(
                width: double.infinity,
                child: Text('Chọn ảnh từ Camera',
                    style: TextStyle(fontSize: 16, color: Colors.black))),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
