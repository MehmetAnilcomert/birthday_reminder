import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:birthday_reminder/product/service/notification/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

/// Concrete implementation of [INotificationService] using Firebase Messaging.
final class FirebaseNotificationService implements INotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'birthday_reminders';
  static const String _channelName = 'Birthday Reminders';
  static const String _channelDescription =
      'Notifications for upcoming birthdays';

  @override
  Future<void> initialize() async {
    // Request permissions first
    await requestPermission();

    // Initialize local notifications for foreground display on Android
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    // Create Android channel
    if (Platform.isAndroid) {
      await _createAndroidChannel();
    }

    // Set foreground notification presentation options for iOS
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Listen for background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle token refresh
    _messaging.onTokenRefresh.listen((token) {
      // Token update logic handled by listener in AuthViewModel or similar
    });
  }

  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            icon: android.smallIcon,
            priority: Priority.max,
            importance: Importance.max,
            actions: [
              const AndroidNotificationAction(
                'send_message',
                'Mesaj Gönder',
                showsUserInterface: true,
              ),
            ],
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  Future<void> _handleNotificationResponse(
    NotificationResponse details,
  ) async {
    if (details.actionId == 'send_message' && details.payload != null) {
      try {
        final data = jsonDecode(details.payload!) as Map<String, dynamic>;
        final message =
            data['greetingMessage'] as String? ?? data['message'] as String?;
        if (message != null && message.isNotEmpty) {
          final uri = Uri.parse(
            'https://wa.me/?text=${Uri.encodeComponent(message)}',
          );
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      } catch (e) {
        // Handle error
      }
    }
  }

  @override
  Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  @override
  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you need to access other Firebase services here, you must initialize them.
  // await Firebase.initializeApp();
  // But usually not needed for simple display.
  print('Handling a background message: ${message.messageId}');
}
