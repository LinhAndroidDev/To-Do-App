
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'date_utils.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(onDidReceiveLocalNotification: (id, title, body, payload) => null);
    const LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (detail) => null);
  }

  static Future showSimpleNotification({required int id, required String title, required String detail}) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        fullScreenIntent: true,);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id, title, detail, notificationDetails,
        payload: "This is simple notification");
  }

  static void triggerNotification() async {
    final map = await readNotificationFromFile();
    final id = map?['id'] ?? '0';
    final title = map?['title'] ?? 'Unknown Data';
    final detail = map?['detail'] ?? 'Unknown Data';

    await showSimpleNotification(id: id as int, title: title, detail: detail);
  }
}