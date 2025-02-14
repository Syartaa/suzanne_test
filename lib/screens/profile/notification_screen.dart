import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:suzanne_podcast_app/provider/notifications_provider.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(198, 243, 18, 18),
        centerTitle: true,
        title: Text(
          "Notifications ",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: const Color(0xFFFFF8F0),
            shadows: [
              const Shadow(
                color: Color(0xFFFFF1F1),
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: notificationsState.when(
        data: (notifications) {
          // Filter notifications for today
          final today = DateTime.now();
          final todayNotifications = notifications.where((n) {
            return n.timestamp.year == today.year &&
                n.timestamp.month == today.month &&
                n.timestamp.day == today.day;
          }).toList();

          if (todayNotifications.isEmpty) {
            return const Center(
              child: Text(
                "No notifications for today.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: todayNotifications.length,
            itemBuilder: (context, index) {
              final notification = todayNotifications[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 231, 32, 32),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.notifications_active,
                        color: AppColors.secondaryColor,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(242, 255, 248, 240),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.body,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('hh:mm a').format(notification.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    trailing: notification.isRead
                        ? null
                        : const Icon(Icons.circle,
                            color: Colors.yellow, size: 12),
                    onTap: () {
                      ref
                          .read(notificationsProvider.notifier)
                          .markAsRead(notification.id);
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
            child:
                Text("Error: $error", style: TextStyle(color: Colors.white))),
      ),
    );
  }
}
