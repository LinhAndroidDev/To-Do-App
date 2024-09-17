
import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/hive/schedule_work.dart';
import 'package:to_do_app/hive/work_hive.dart';
import 'package:to_do_app/model/time_work.dart';
import 'package:to_do_app/sharepreference.dart';

class MainController extends GetxController {
  late Box<Work> box;
  late Box<ScheduleWork> boxSchedule;
  var works = <Work>[];
  var time = ''.obs;
  var imageAvatar = ''.obs;
  var filteredItems = <Work>[].obs;
  var timeWorks = <TimeWork>[];
  var indexSelectedTime = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    imageAvatar.value = await SharePreferData.loadAvatar();
    getSevenDays();
    box = await Hive.openBox<Work>('work');
    boxSchedule = await Hive.openBox<ScheduleWork>('schedule');
    getWorks();
  }

  /// Add Schedule Work to Hive
  Future<void> addScheduleWork(ScheduleWork scheduleWork) async {
    await boxSchedule.add(scheduleWork);
  }

  /// Add work to Hive
  Future<void> addWork(Work work) async {
    await box.add(work);
    filteredItems.add(work);
    works = filteredItems;
  }

  /// Get all works from Hive
  Future<void> getWorks() async {
    works = box.values.toList();
    filteredItems.value = works;
  }

  /// Update work in Hive
  Future<void> updateWork(int index, Work work) async {
    int position = works.indexWhere((element) => element.id == filteredItems[index].id);
    await box.putAt(position, work);
    filteredItems[index] = work;
    update(); // Gọi để cập nhật UI nếu cần
    works = box.values.toList();
  }

  /// Delete work in Hive
  Future<void> deleteWork(int index) async {
    int position = works.indexWhere((element) => element.id == filteredItems[index].id);
    await box.deleteAt(position);
    filteredItems.removeAt(index);
    works = box.values.toList();
  }

  /// Turn on/off notification
  Future<void> turnOnNotification(int index, Work work) async {
    work.haveNotice = work.haveNotice == true ? false : true;
    filteredItems[index] = work;
    int position = works.indexWhere((element) => element.id == filteredItems[index].id);
    await updateWork(position, work);
    works = box.values.toList();
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

  ///Get List Of 7 Consecutive Days From Current Date
  Future<void> getSevenDays() async {
    DateTime today = DateTime.now();
    List<TimeWork> timeWorks = [];

    // Sử dụng vòng lặp để thêm các ngày liên tiếp vào danh sách
    for (int i = 0; i < 7; i++) {
      DateTime day = today.add(Duration(days: i));
      timeWorks.add(TimeWork(day: day.day, dayOfWeek: DateFormat('E').format(day)));
    }
    this.timeWorks = timeWorks;
  }
}