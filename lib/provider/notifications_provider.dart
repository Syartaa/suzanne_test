import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suzanne_podcast_app/models/notification.dart';

class NotificationsNotifier
    extends StateNotifier<AsyncValue<List<AppNotification>>> {
  NotificationsNotifier() : super(const AsyncValue.loading()) {
    fetchNotifications();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final readIds = prefs.getStringList('read_notifications') ?? [];

    _firestore
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((querySnapshot) {
      final notifications = querySnapshot.docs.map((doc) {
        final notif = AppNotification.fromFirestore(doc);
        return notif.copyWith(isRead: readIds.contains(notif.id));
      }).toList();

      state = AsyncValue.data(notifications);
    });
  }

  /// **Mark a single notification as read (locally + persist)**
  Future<void> markAsRead(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readIds = prefs.getStringList('read_notifications') ?? [];

    if (!readIds.contains(notificationId)) {
      readIds.add(notificationId);
      await prefs.setStringList('read_notifications', readIds);
    }

    state = AsyncValue.data(
      state.value?.map((n) {
            if (n.id == notificationId) {
              return n.copyWith(isRead: true);
            }
            return n;
          }).toList() ??
          [],
    );
  }

  /// **Mark all notifications as read (local only + persist)**
  Future<void> markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    final allIds = state.value?.map((n) => n.id).toList() ?? [];
    await prefs.setStringList('read_notifications', allIds);

    state = AsyncValue.data(
      state.value?.map((n) => n.copyWith(isRead: true)).toList() ?? [],
    );
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier,
    AsyncValue<List<AppNotification>>>(
  (ref) => NotificationsNotifier(),
);
