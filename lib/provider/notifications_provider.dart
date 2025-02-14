import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suzanne_podcast_app/models/notification.dart';

class NotificationsNotifier
    extends StateNotifier<AsyncValue<List<AppNotification>>> {
  NotificationsNotifier() : super(const AsyncValue.loading()) {
    fetchNotifications();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchNotifications() async {
    try {
      final querySnapshot = await _firestore
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      final notifications = querySnapshot.docs.map((doc) {
        final notif = AppNotification.fromFirestore(doc);
        return notif.copyWith(isRead: false); // Always mark as unread initially
      }).toList();

      state = AsyncValue.data(notifications);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// **Get unread notification count (local)**
  int getUnreadCount() {
    return state.value?.where((n) => !n.isRead).length ?? 0;
  }

  /// **Mark all notifications as read (local only, NOT Firestore)**
  void markAllAsRead() {
    state = AsyncValue.data(
      state.value?.map((n) => n.copyWith(isRead: true)).toList() ?? [],
    );
  }

  /// **Mark a single notification as read (local)**
  void markAsRead(String notificationId) {
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
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier,
    AsyncValue<List<AppNotification>>>(
  (ref) => NotificationsNotifier(),
);
