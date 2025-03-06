import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suzanne_podcast_app/firebase_options.dart';
import 'package:suzanne_podcast_app/l10n/app_localizations.dart';
import 'package:suzanne_podcast_app/navigation_menu.dart';
import 'package:suzanne_podcast_app/notifications/notification_service.dart';
import 'package:suzanne_podcast_app/notifications/request_permission.dart';
import 'package:suzanne_podcast_app/provider/locale_provider.dart';
import 'package:suzanne_podcast_app/screens/onboarding/onboarding_screen.dart';
import 'package:suzanne_podcast_app/utilis/theme/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// 🔹 Background message handler (must be a top-level function)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(
      "\ud83d\udce9 [Background] Notification received: \${message.notification?.title}");
  NotificationService.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Notifications
  NotificationService.initialize();

  // Lock screen orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Check user login status
  final isUserLoggedIn = await _checkUserLoggedIn();

  runApp(ProviderScope(child: MyApp(isUserLoggedIn: isUserLoggedIn)));
}

class MyApp extends ConsumerStatefulWidget {
  final bool isUserLoggedIn;

  const MyApp({Key? key, required this.isUserLoggedIn}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends ConsumerState<MyApp> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    requestPermission();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.getToken().then((token) {
      print("\ud83d\udd11 Firebase Device Token: \$token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          '\ud83d\udce5 Foreground Notification: \${message.notification?.title}');
      if (message.notification != null) {
        NotificationService.showNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          '\ud83d\udce2 [Opened] Notification tapped: \${message.notification?.title}');
      if (message.data['screen'] == 'home') {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NavigationMenu(),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    print("\ud83c\udf0d Selected Language: \${locale.languageCode}");

    return MaterialApp(
      navigatorKey: navigatorKey, // ✅ Uses global navigatorKey
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lighTheme,
      navigatorObservers: <NavigatorObserver>[
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('sq'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: widget.isUserLoggedIn ? NavigationMenu() : const OnboardingScreen(),
    );
  }
}

Future<bool> _checkUserLoggedIn() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    return userData != null;
  } catch (e) {
    print("❌ Error checking login status: \$e");
    return false;
  }
}
