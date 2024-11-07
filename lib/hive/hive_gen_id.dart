import 'package:hive/hive.dart';

class HiveIdGenerator {
  static Future<int> getNextId() async {
    final idBox = await Hive.openBox<int>('idBox');
    int currentId = idBox.get('id', defaultValue: 0)!;
    currentId += 1;
    await idBox.put('id', currentId);
    return currentId;
  }

  static Future<int> getScheduleWorkId() async {
    final idBox = await Hive.openBox<int>('scheduleWorkId');
    int currentId = idBox.get('scheduleId', defaultValue: 0)!;
    currentId += 1;
    await idBox.put('scheduleId', currentId);
    return currentId;
  }
}