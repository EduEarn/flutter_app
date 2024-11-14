import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../model/notification_entity.dart';

class NotificationRepository {
  static const String key = 'notifications';

  Future<void> saveNotification(NotificationEntity notification) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getNotifications();
    notifications.add(notification);
    await prefs.setString(key, jsonEncode(notifications.map((notification) => notification.toMap()).toList()));
  }

  Future<List<NotificationEntity>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString(key);
    if (notificationsJson == null) return [];
    final notificationsMap = jsonDecode(notificationsJson) as List;
    return notificationsMap.map((e) => NotificationEntity.fromMap(e)).toList();
  }

  Future<void> deleteNotification(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getNotifications();
    notifications.removeWhere((notification) => notification.id == id);
    await prefs.setString(key, jsonEncode(notifications.map((e) => e.toMap()).toList()));
  }

  Future<void> deleteAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getNotifications();
    for (final notification in notifications) {
      notification.isRead = true;
    }
    await prefs.setString(key, jsonEncode(notifications.map((e) => e.toMap()).toList()));
  }

  Future<int> getUnreadNotificationCount() async {
    final notifications = await getNotifications();
    return notifications.where((notification) => !notification.isRead).length;
  }
}
