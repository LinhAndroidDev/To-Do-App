import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:to_do_app/color_name.dart';
import 'package:to_do_app/custom_view/custom_dialog_create.dart';
import 'package:to_do_app/custom_view/custom_search_view.dart';
import 'package:to_do_app/local_notification.dart';
import 'package:to_do_app/work_view.dart';
import 'date_utils.dart';
import 'hive/schedule_work.dart';
import 'hive/work_hive.dart';
import 'main_controller.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(WorkAdapter()); // Đăng ký adapter
  Hive.registerAdapter(ScheduleWorkAdapter()); // Đăng ký adapter
  await Hive.openBox<Work>('work');
  await Hive.openBox<ScheduleWork>('schedule');

  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.init();
  await AndroidAlarmManager.initialize();

  // Kiểm tra và xin quyền notification trước
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // Sau khi xin xong quyền notification, kiểm tra và xin quyền exact alarm
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

void scheduleDailyNotification({required Work work}) async {
  final time = stringToTimeOfDay(work.schedule ?? '');

  // Tính toán thời gian cho lần báo thức tiếp theo
  DateTime now = DateTime.now();
  DateTime firstAlarmTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

  saveNotificationToFile(id: work.id, title: work.title, detail: work.detail, schedule: work.schedule ?? '');

  if (now.isAfter(firstAlarmTime)) {
    firstAlarmTime = firstAlarmTime.add(const Duration(days: 1));
  }

  // Đặt báo thức
  await AndroidAlarmManager.oneShotAt(
    firstAlarmTime,
    work.id,
    LocalNotification.triggerNotification,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("TO DO APP"),
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          actions: [
            Obx(
              () => InkWell(
                onTap: () {
                  Get.bottomSheet(_builderBottomSheet(context),
                      isDismissible: true);
                },
                child: viewAvatar(),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: contentView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(DialogCustomCreateWork(onClickCreate: (work) {
              controller.addWork(work);
            }));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget contentView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomSearchView(
              keySearch: (value) => {controller.searchWork(value)}),
          SizedBox(
            height: 80,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.timeWorks.length,
                itemBuilder: (context, index) {
                  return viewTimeWorking(index: index);
                }),
          ),
          Obx(() {
            // Hiển thị thông báo nếu không có công việc
            if (controller.filteredItems.isEmpty) {
              return const Center(child: Text("Không có công việc nào"));
            }
            return Container(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return swipeItemTimeLine(context: context, index: index);
                  }),
            );
          }),
        ],
      ),
    );
  }

  Widget viewTimeWorking({required int index}) {
    return Row(
      children: [
        SizedBox(
          width: (index == 0) ? 10 : 0,
        ),
        InkWell(
          onTap: () {
            controller.indexSelectedTime.value = index;
          },
          child: Obx(() => Container(
            width: controller.timeWorks.isNotEmpty ? 60 : 0,
            height: controller.timeWorks.isNotEmpty ? 60 : 0,
            decoration: BoxDecoration(
              color:
              (index == controller.indexSelectedTime.value) ? ColorName.blue : ColorName.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                (index == controller.indexSelectedTime.value)
                    ? const BoxShadow(
                  color: ColorName.greyDark,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
                    : const BoxShadow(color: ColorName.white),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.timeWorks[index].day.toString(),
                  style: TextStyle(
                      fontSize: 16,
                      color: (index == controller.indexSelectedTime.value)
                          ? ColorName.white
                          : ColorName.black,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  controller.timeWorks[index].dayOfWeek,
                  style: TextStyle(
                    fontSize: 14,
                    color: (index == controller.indexSelectedTime.value)
                        ? ColorName.white
                        : ColorName.black,
                  ),
                )
              ],
            ),
          )),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }

  Widget viewAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: controller.imageAvatar.isNotEmpty
          ? CircleAvatar(
              radius: 20, // Điều chỉnh kích thước ảnh tròn
              backgroundImage: FileImage(File(controller.imageAvatar.value)),
            )
          : const CircleAvatar(
              radius: 20, // Điều chỉnh kích thước ảnh tròn
              child: Icon(Icons.person, color: ColorName.white,)),
    );
  }

  ///Create List Can Swipe
  Widget swipeItemTimeLine(
      {required BuildContext context, required int index}) {
    return Column(
      children: [
        InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogCustomCreateWork(
                    onClickCreate: (work) {
                      controller.updateWork(index, work);
                    },
                    work: controller.filteredItems[index],
                    isCreate: false,
                  );
                },
              );
            },
            child: Slidable(
              endActionPane: ActionPane(
                extentRatio: 0.18,
                motion: const DrawerMotion(),
                children: [
                  itemActionSlidable(onDelete: (delete) {
                    delete ? controller.deleteWork(index) : null;
                  }),
                ],
              ),
              child: WorkView(
                  work: controller.filteredItems[index],
                  turnOnNotification: (value) => {
                        value
                            ? scheduleDailyNotification(
                                work: controller.filteredItems[index])
                            : AndroidAlarmManager.cancel(
                                controller.filteredItems[index].id),
                    controller.turnOnNotification(index, controller.filteredItems[index])
                      }),
            )),
        SizedBox(
          height: (index == controller.filteredItems.length - 1) ? 80 : 10,
        )
      ],
    );
  }

  Widget itemActionSlidable({required ValueChanged<bool> onDelete}) {
    return CustomSlidableAction(
      onPressed: (context) {
        onDelete(true);
      },
      backgroundColor: ColorName.greyDark,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: const Icon(
        Icons.delete_forever,
        size: 23,
        color: ColorName.white,
      ),
    );
  }

  Widget _builderBottomSheet(BuildContext context) {
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
              controller.pickImage();
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
              controller.pickCamera();
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
