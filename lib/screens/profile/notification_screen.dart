import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:suzanne_podcast_app/provider/notifications_provider.dart';
import 'package:suzanne_podcast_app/screens/podcasts/podcast_screen.dart';
import 'package:suzanne_podcast_app/screens/schedules/monday_marks_screen.dart';
import 'package:suzanne_podcast_app/utilis/constants/size.dart';
import 'package:suzanne_podcast_app/utilis/theme/custom_themes/appbar_theme.dart';
import 'package:suzanne_podcast_app/models/notification.dart';

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
            fontSize: ScreenSize.width > 600 ? 28 : 24, // Adjust font size
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
          final today = DateTime.now();

          // Filter Today's Notifications
          final todayNotifications = notifications.where((n) {
            return n.timestamp.year == today.year &&
                n.timestamp.month == today.month &&
                n.timestamp.day == today.day;
          }).toList();

          // Filter Older Notifications
          final olderNotifications = notifications.where((n) {
            return n.timestamp.isBefore(
              DateTime(today.year, today.month, today.day),
            );
          }).toList();

          return notifications.isEmpty
              ? const Center(
                  child: Text(
                    "No notifications available.",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : ListView(
                  children: [
                    if (todayNotifications.isNotEmpty) ...[
                      _buildSectionTitle("Today's Notifications"),
                      ...todayNotifications.map((notification) =>
                          _buildNotificationTile(notification, ref, context)),
                    ],
                    if (olderNotifications.isNotEmpty) ...[
                      _buildSectionTitle("Older Notifications"),
                      ...olderNotifications.map((notification) =>
                          _buildNotificationTile(notification, ref, context)),
                    ],
                  ],
                );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text("Error: $error", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  /// **Build Section Title Widget**
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.width > 600 ? 24.0 : 16.0, // Adjust padding
        vertical: 10,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: ScreenSize.width > 600 ? 20 : 18, // Adjust font size
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    );
  }

  /// **Build Notification Tile with Navigation**
  Widget _buildNotificationTile(
      AppNotification notification, WidgetRef ref, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ScreenSize.width > 600 ? 12.0 : 8.0, // Adjust padding
        horizontal: ScreenSize.width > 600 ? 16.0 : 10.0,
      ),
      child: Container(
        padding: EdgeInsets.all(
            ScreenSize.width > 600 ? 16.0 : 12.0), // Adjust padding
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 231, 32, 32),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: ScreenSize.width > 600 ? 30 : 20, // Adjust avatar size
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.notifications_active,
              color: AppColors.secondaryColor,
              size: ScreenSize.width > 600 ? 30 : 24, // Adjust icon size
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontSize: ScreenSize.width > 600 ? 16 : 14, // Adjust font size
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(242, 255, 248, 240),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.body,
                style: TextStyle(
                  fontSize:
                      ScreenSize.width > 600 ? 14 : 12, // Adjust font size
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('yyyy-MM-dd hh:mm a').format(notification.timestamp),
                style: TextStyle(
                  fontSize:
                      ScreenSize.width > 600 ? 14 : 12, // Adjust font size
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          trailing: notification.isRead
              ? null
              : const Icon(Icons.circle, color: Colors.yellow, size: 12),
          onTap: () {
            // Mark notification as read
            ref
                .read(notificationsProvider.notifier)
                .markAsRead(notification.id);

            // Navigate based on notification type
            if (notification.type == "podcast") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PodcastScreen(),
                ),
              );
            } else if (notification.type == "monday mark") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MondayMarksScreen(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
