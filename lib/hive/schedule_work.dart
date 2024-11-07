import 'package:hive/hive.dart';

import 'work_hive.dart';

part 'schedule_work.g.dart';

@HiveType(typeId: 1)
class ScheduleWork extends HiveObject {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  List<Work> works;

  ScheduleWork({required this.id, required this.dateTime, required this.works});
}