import 'package:hive/hive.dart';

import 'work_hive.dart';

part 'schedule_work.g.dart';

@HiveType(typeId: 1)
class ScheduleWork extends HiveObject {
  @HiveField(0)
  DateTime? dateTime;

  @HiveField(1)
  List<Work>? works;

  ScheduleWork({required this.dateTime, required this.works});
}