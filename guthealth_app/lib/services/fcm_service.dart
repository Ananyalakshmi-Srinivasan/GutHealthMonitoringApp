import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/survey_screen.dart';
import '../screens/login_screen.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String symptomReminderChannelId = 'symptom_reminders';
  static const String symptomReminderChannelName = 'Symptom Reminders';
  static const String symptomReminderChannelDescription =
      'Notifications reminding users to log symptoms';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize({ //kept american spelling for consistency with the plugin's method names
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    await _initializeLocalNotifications(navigatorKey);
    await _createAndroidChannel();
    _listenToForegroundMessages();
    _listenToNotificationTaps(navigatorKey);
  }

  Future<void> handlePostLoginNotificationSetup() async {
    final hasPermission = await _requestPermission();

    if (!hasPermission) {
      return;
    }

    await _subscribeToReminderTopic();

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM token: $token');
  }


  Future<bool> _requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    return _isAuthorized(settings);
  }

  bool _isAuthorized(NotificationSettings settings) {
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }


  Future<void> _initializeLocalNotifications(
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleRoute(response.payload, navigatorKey);
      },
    );
  }


  Future<void> _createAndroidChannel() async { // creating a notification channel for Android to group notifications and set importance
    const channel = AndroidNotificationChannel(
      symptomReminderChannelId,
      symptomReminderChannelName,
      description: symptomReminderChannelDescription,
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _subscribeToReminderTopic() async { // subscribing the device to a topic so it can receive topic-based notifications
    await FirebaseMessaging.instance.subscribeToTopic(
      'biweekly_symptom_reminder',
    );
    debugPrint('Subscribed to biweekly_symptom_reminder');
  }

  void _listenToForegroundMessages() { // listening for messages when the app is in the foreground and showing a local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;

      if (notification == null) return;

      await _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            symptomReminderChannelId,
            symptomReminderChannelName,
            channelDescription: symptomReminderChannelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: message.data['route'],
      );

    });
  }

  void _listenToNotificationTaps(GlobalKey<NavigatorState> navigatorKey) { // listening for when a user taps on a notification and navigating to the appropriate screen based on the payload
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await _handleRoute(message.data['route'], navigatorKey);
    });
  }

  Future<void> handleInitialMessage( // handling the case where the app is opened from a terminated state via a notification tap
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      await _handleRoute(initialMessage.data['route'], navigatorKey);
    }
  }

  Future<void> _handleRoute(
    String? route,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    if (route != '/survey') return;

    final prefs = await SharedPreferences.getInstance();
    final customerId = prefs.getInt('customerId');

    if (customerId == null) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }
    debugPrint('Notification route received: $route');

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => SurveyScreen(customerId: customerId),
      ),
    );
  }

}
