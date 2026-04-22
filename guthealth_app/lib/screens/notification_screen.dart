import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final IconData icon;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.icon,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Mock Symptom Reminder',
      message: 'Don’t forget to log your symptoms for today.',
      time: '2 min ago',
      isRead: false,
      icon: Icons.monitor_heart,
    ),
    NotificationItem(
      title: 'Mock Mood Log Reminder',
      message: 'Don’t forget to log your mood for today.',
      time: '1 hour ago',
      isRead: false,
      icon: Icons.mood,
    ),
    NotificationItem(
      title: 'Mock Recipe Suggestion',
      message: 'We found a new recipe that may help with your symptoms.',
      time: 'Yesterday',
      isRead: true,
      icon: Icons.restaurant,
    ),

  ];

  void markAllAsRead() {
    setState(() {
      notifications = notifications.map((item) {
        return NotificationItem(
          title: item.title,
          message: item.message,
          time: item.time,
          isRead: true,
          icon: item.icon,
        );
      }).toList();
    });
  }

  void markOneAsRead(int index) {
    setState(() {
      notifications[index] = NotificationItem(
        title: notifications[index].title,
        message: notifications[index].message,
        time: notifications[index].time,
        isRead: true,
        icon: notifications[index].icon,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B9FAE),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Notifications - mock page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: markAllAsRead,
            child: const Text(
              'Mark all read',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
        child: Text(
          'No notifications yet',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = notifications[index];

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => markOneAsRead(index),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: item.isRead
                    ? Colors.white
                    : const Color(0xFFEAF7F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF1B9FAE).withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFE0868D),
                    child: Icon(
                      item.icon,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1B9FAE),
                                ),
                              ),
                            ),
                            if (!item.isRead)
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.message,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}