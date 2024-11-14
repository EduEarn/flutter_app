class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  bool isRead;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory NotificationEntity.fromMap(Map<String, dynamic> map) {
    return NotificationEntity(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      createdAt: DateTime.parse(map['createdAt']),
      isRead: map['isRead'] as bool? ?? false,
    );
  }
}
