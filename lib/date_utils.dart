import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

String timeOfDayToString(TimeOfDay time, BuildContext context) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

TimeOfDay stringToTimeOfDay(String timeString) {
  final format = DateFormat.Hm(); // 24-hour format
  return TimeOfDay.fromDateTime(format.parse(timeString));
}

String convertIntToString(int number) {
  return number < 10 ? '0$number' : number.toString();
}

String getCurrentTime() {
  final now = DateTime.now();
  final DateFormat formatter = DateFormat('HH:mm');
  return formatter.format(now); // Trả về thời gian hiện tại dưới dạng "HH:mm"
}

Future<void> saveNotificationToFile({
  required int id,
  required String title,
  required String detail,
  required String schedule,
}) async {
  // Lấy đường dẫn thư mục tài liệu của thiết bị
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/notifications_$schedule.json';

  // Tạo đối tượng dữ liệu cần lưu
  final notificationData = {
    'id': id,
    'title': title,
    'detail': detail,
    'schedule': schedule,
  };

  // Chuyển đối tượng dữ liệu thành JSON
  final jsonData = jsonEncode(notificationData);

  // Lưu dữ liệu JSON vào file
  final file = File(path);
  await file.writeAsString(jsonData);
}

Future<Map<String, dynamic>?> readNotificationFromFile() async {
  // Lấy đường dẫn thư mục tài liệu của thiết bị
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/notifications_${getCurrentTime()}.json';

  final file = File(path);

  // Kiểm tra xem file có tồn tại không
  if (await file.exists()) {
    // Đọc dữ liệu từ file
    final jsonData = await file.readAsString();
    // Chuyển đổi dữ liệu JSON thành Map
    return jsonDecode(jsonData);
  } else {
    // Nếu file không tồn tại, trả về null
    return null;
  }
}