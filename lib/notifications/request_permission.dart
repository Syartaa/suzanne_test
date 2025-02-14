import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    announcement: false,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("✅ User granted permission");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print("⚠️ User granted provisional permission");
  } else {
    print("❌ User denied permission");
  }
}
