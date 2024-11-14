import 'dart:convert';

import 'package:edu_earn/src/notification/screens/notification.dart';
import 'package:edu_earn/src/notification/service/repository/notification_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

import '../model/notification_entity.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final NotificationRepository _repository = NotificationRepository();

  static Future<void> onDidReceiveNotification(NotificationResponse notificationResponse) async {
    print("Notification received");
    final String? payload = notificationResponse.payload;
    print("payload: $payload");
    if (payload != null) {
      try {
        await _repository.markAllAsRead();
        Get.to(() => NotificationPage());
      } catch (e) {
        Get.to(() => NotificationPage());
      }
    } else {
      Get.to(() => NotificationPage());
    }
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showInstantNotification(int id, String title, String body, {String? payload}) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_notification_channel_id',
        'Instant Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload ?? 'instant_notification',
    );
    final notification = NotificationEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );
    await _repository.saveNotification(notification);
  }

  static Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
