import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/color_name.dart';
import 'package:to_do_app/date_utils.dart';
import 'package:to_do_app/hive/hive_gen_id.dart';

import '../hive/work_hive.dart';
import 'dialog_create_controller.dart';

class DialogCustomCreateWork extends StatelessWidget {
  DialogCustomCreateWork({
    super.key,
    required this.onClickCreate,
    this.work,
    this.isCreate = true,
  });

  final ValueChanged<Work> onClickCreate;
  final Work? work;
  final bool isCreate;

  final controller = Get.put(DialogCreateController());

  @override
  Widget build(BuildContext context) {
    controller.titleController.text = work?.title ?? '';
    controller.detailController.text = work?.detail ?? '';
    controller.timeSelected.value = work != null
        ? stringToTimeOfDay(work!.schedule!)
        : const TimeOfDay(hour: 0, minute: 0);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 16,
      child: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    isCreate ? 'Tạo Công Việc Cần Làm' : 'Chỉnh sửa công việc',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  )),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(
                    labelText: 'Nhập tên công việc',
                    labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không để trống trường này';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: controller.detailController,
                  decoration: const InputDecoration(
                    labelText: 'Nhập chi tiết công việc',
                    labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không để trống trường này';
                    }
                    return null;
                  },
                ),
              ),
              InkWell(
                onTap: () async {
                  await showTimePicker(
                    context: context,
                    initialTime: controller.timeSelected.value,
                  ).then((time) {
                    if (time != null) {
                      controller.timeSelected.value = time;
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorName.white,
                    boxShadow: [
                      BoxShadow(
                        color: ColorName.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Obx(() =>
                      Text(
                        '${convertIntToString(controller.timeSelected.value.hour)}:${convertIntToString(controller.timeSelected.value.minute)}',
                        style: const TextStyle(
                            color: ColorName.black, fontSize: 14),
                      )),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorName.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Đóng',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          onClickCreate(Work(
                            id: work?.id ?? await HiveIdGenerator.getNextId(),
                            title: controller.title,
                            detail: controller.detail,
                            schedule: timeOfDayToString(controller.timeSelected.value, context),
                            timeCreate: DateTime.now(),
                            haveNotice: work?.haveNotice ?? false,
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorName.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isCreate ? 'Tạo Công Việc' : 'Sửa Công việc',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
