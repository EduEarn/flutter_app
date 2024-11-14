import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/data/image_assets.dart';
import '../model/notification_entity.dart';
import '../service/repository/notification_repository.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationRepository _repository = NotificationRepository();
  Map<String, List<NotificationEntity>> _groupedNotifications = {};

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await _repository.getNotifications();
    setState(() {
      _groupedNotifications = _groupNotificationsByDate(notifications);
    });
  }

  Map<String, List<NotificationEntity>> _groupNotificationsByDate(List<NotificationEntity> notifications) {
    final groupedNotifications = LinkedHashMap<String, List<NotificationEntity>>();
    final now = DateTime.now();

    groupedNotifications['Today'] = [];
    groupedNotifications['Yesterday'] = [];

    for (final notification in notifications) {
      final notificationDate = notification.createdAt;
      String dateKey;

      if (notificationDate.year == now.year && notificationDate.month == now.month && notificationDate.day == now.day) {
        dateKey = 'Today';
      } else if (notificationDate.year == now.year &&
          notificationDate.month == now.month &&
          notificationDate.day == now.day - 1) {
        dateKey = 'Yesterday';
      } else {
        dateKey = DateFormat('MMMM d, yyyy').format(notificationDate);
      }

      if (!groupedNotifications.containsKey(dateKey)) {
        groupedNotifications[dateKey] = [];
      }
      groupedNotifications[dateKey]!.add(notification);
    }
    groupedNotifications.removeWhere((key, value) => value.isEmpty);

    return groupedNotifications;
  }

  Future<void> _deleteNotification(NotificationEntity notification) async {
    await _repository.deleteNotification(notification.id);
    await _loadNotifications();
  }

  Future<void> _clearAllNotifications() async {
    await _repository.deleteAllNotifications();
    await _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Alerts",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),
        ),
        actions: [
          if (_groupedNotifications.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: Container(
                        alignment: Alignment.topCenter,
                        width: 384,
                        height: 175,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text(
                              'Clear All Notifications',
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 17),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Are you sure you want to delete all notifications?',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : Theme.of(context).colorScheme.primary,
                                      minimumSize: const Size(120, 40),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _clearAllNotifications();
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : Theme.of(context).colorScheme.primary,
                                      minimumSize: const Size(120, 40),
                                    ),
                                    child: Text(
                                      'Clear All',
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFFFE28D),
              foregroundImage: AssetImage(ImageAssets.profile),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _groupedNotifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageAssets.bell,
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 16),
                    const Text("You don't have any notifications"),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _groupedNotifications.length,
                itemBuilder: (context, index) {
                  final dateKey = _groupedNotifications.keys.elementAt(index);
                  final notifications = _groupedNotifications[dateKey]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          dateKey,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: notifications.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return Dismissible(
                            key: Key(notification.id),
                            background: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red,
                              ),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              _deleteNotification(notification);
                            },
                            child: Card(
                              elevation: 0,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[800]!
                                  : const Color(0xffF9F7FB),
                              child: ListTile(
                                leading: Icon(
                                  Icons.notifications,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Color(0xFFFFE28D)
                                      : Theme.of(context).primaryColor,
                                  size: 40,
                                ),
                                title: Text(
                                  notification.title,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notification.body),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
