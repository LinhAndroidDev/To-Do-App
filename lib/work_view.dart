
import 'package:flutter/material.dart';
import 'package:to_do_app/hive/work_hive.dart';

import 'color_name.dart';

class WorkView extends StatelessWidget {
  const WorkView({
    super.key,
    required this.work,
    required this.turnOnNotification
  });

  final Work work;
  final ValueChanged<bool> turnOnNotification;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          color: ColorName.yellow,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                work.title,
                style: const TextStyle(
                    fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    work.detail,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  work.haveNotice == false
                      ? turnOnNotification(true)
                      : turnOnNotification(false);
                  //     ? scheduleDailyNotification(work: work)
                  //     : AndroidAlarmManager.cancel(work.id);
                  // turnOnNotification(work.id);
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorName.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        work.haveNotice == true
                            ? BoxShadow(
                          color: ColorName.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ) : const BoxShadow(color: ColorName.white),
                      ],
                    ),
                    child: work.haveNotice == true
                        ? const Icon(Icons.notifications, size: 20, color: ColorName.black,)
                        : const Icon(Icons.notifications_off, size: 20, color: ColorName.greyDark,)
                ),
              ),
            ))
      ],
    );
  }
}
