import 'package:hive/hive.dart';

part 'work_hive.g.dart';

@HiveType(typeId: 0)
class Work extends HiveObject {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  String title;

  @HiveField(2)
  String detail;

  @HiveField(3)
  String? schedule;

  @HiveField(4)
  bool? haveNotice;

  @HiveField(5)
  DateTime? timeCreate;

  Work({
    required this.id,
      required this.title,
      required this.detail,
      required this.schedule,
      this.haveNotice = false,
      required this.timeCreate
  });
}