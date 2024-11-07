
import 'package:collection/collection.dart';
import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_app/date_utils.dart';
import 'package:to_do_app/hive/schedule_work.dart';
import 'package:to_do_app/hive/work_hive.dart';
import 'package:to_do_app/sharepreference.dart';

import 'hive/hive_gen_id.dart';

class MainController extends GetxController {
  final boxSchedule = Hive.box<ScheduleWork>('schedule');
  var works = <Work>[];
  var time = ''.obs;
  var imageAvatar = ''.obs;
  var filteredItems = <Work>[].obs;
  var timeWorks = <DateTime>[];
  var dateTimeCurrent = DateTime.now().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    imageAvatar.value = await SharePreferData.loadAvatar();
    getSevenDays();
    await getScheduleWork();
  }

  @override
  void dispose() {
    Hive.box('schedule').close();// Đóng tất cả các hộp
    super.dispose();
  }

  /// Add Schedule Work to Hive
  Future<void> getScheduleWork() async {
    final schedule = boxSchedule.values.firstWhereOrNull(
            (schedule) => compareDay(schedule.dateTime, dateTimeCurrent.value));
    works = schedule?.works ?? [];
    filteredItems.value = works;
    filteredItems.refresh();
  }

  /// Add Schedule Work to Hive
  Future<void> addScheduleWork(ScheduleWork scheduleWork) async {
    await boxSchedule.add(scheduleWork);
  }

  /// Add Work to Schedule
  Future<void> addWorkToSchedule(Work work) async {
    // Tìm ScheduleWork của ngày hiện tại
    var scheduleWork = boxSchedule.values.firstWhereOrNull(
          (schedule) => compareDay(schedule.dateTime, dateTimeCurrent.value),
    );

    if (scheduleWork != null) {
      scheduleWork.works.add(work);
      scheduleWork.save();
    } else {
      final id = await HiveIdGenerator.getScheduleWorkId();
      await addScheduleWork(ScheduleWork(
          id: id, dateTime: dateTimeCurrent.value, works: [work]));
    }

    await getScheduleWork();
  }

  /// Update Work to Schedule
  Future<void> updateWorkToSchedule(int index, Work work) async {
    ScheduleWork schedule = boxSchedule.values.firstWhere(
        (element) => element.dateTime == dateTimeCurrent.value,
        orElse: () => ScheduleWork(id: -1, dateTime: DateTime.now(), works: []));

    if (schedule.id != -1) {
      schedule.works[index] = work;
      await boxSchedule.put(schedule.key, schedule);
    } else {
      print('Fail Update');
    }

    await getScheduleWork();
  }

  /// Delete Work to Schedule
  Future<void> deleteWorkToSchedule(int index) async {
    ScheduleWork schedule = boxSchedule.values.firstWhere(
        (element) => element.dateTime == dateTimeCurrent.value,
        orElse: () => ScheduleWork(id: -1, dateTime: DateTime.now(), works: []));

    if (schedule.id != -1) {
      schedule.works.removeAt(index);
      await boxSchedule.put(schedule.key, schedule);
    } else {
      print('Fail Delete');
    }

    await getScheduleWork();
  }

  /// Turn on/off notification
  Future<void> turnOnNotification(int index, Work work) async {
    work.haveNotice = work.haveNotice == true ? false : true;
    filteredItems[index] = work;
    int position = works.indexWhere((element) => element.id == filteredItems[index].id);
    await updateWorkToSchedule(position, work);
    // works = box.values.toList();
  }

  /// Take Image From Gallery
  void pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageAvatar.value = pickedFile.path;
      SharePreferData.saveAvatar(pickedFile.path);
    } else {
      const GetSnackBar(title: 'Notification', message: 'No image selected', duration: Duration(seconds: 2),).show();
    }
  }

  /// Take Image From Camera
  void pickCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageAvatar.value = pickedFile.path;
    } else {
      const GetSnackBar(title: 'Notification', message: 'No image selected', duration: Duration(seconds: 2),).show();
    }
  }

  /// Search Work By Name Of Work
  void searchWork(String keySearch) {
    keySearch.isEmpty
        ? filteredItems.value = works
        : filteredItems.value = works
            .where((work) => removeDiacritics(work.title.toLowerCase())
                .contains(removeDiacritics(keySearch.toLowerCase())))
            .toList();
  }

  /// Get List Of 7 Consecutive Days From Current Date
  Future<void> getSevenDays() async {
    DateTime today = DateTime.now();
    dateTimeCurrent.value = today;
    List<DateTime> timeWorks = [];

    // Sử dụng vòng lặp để thêm các ngày liên tiếp vào danh sách
    for (int i = 0; i < 7; i++) {
      DateTime day = today.add(Duration(days: i));
      timeWorks.add(day);
    }
    this.timeWorks = timeWorks;
  }

  /// Check if Time is Selected
  bool isTimeSelected({required int index}) {
    return dateTimeCurrent.value == timeWorks[index];
  }

  /// Select Time
  void selectTime({required int index}) {
    dateTimeCurrent.value = timeWorks[index];
    getScheduleWork();
  }
}