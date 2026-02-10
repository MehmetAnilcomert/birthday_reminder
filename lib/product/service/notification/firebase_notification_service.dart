import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/service/notification/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
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

  static Future<void> showNotification(RemoteMessage message) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = message.notification?.android;
    final title =
        message.notification?.title ?? message.data['title'] as String?;
    final body = message.notification?.body ?? message.data['body'] as String?;

    if (title != null && body != null) {
      await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            priority: Priority.max,
            importance: Importance.max,
            actions: [
              AndroidNotificationAction(
                'send_message',
                LocaleKeys.send_wish.tr(),
                showsUserInterface: true,
              ),
            ],
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    showNotification(message);
  }

  Future<void> _handleNotificationResponse(
    NotificationResponse details,
  ) async {
    if (details.actionId == 'send_message' && details.payload != null) {
      try {
        final data = jsonDecode(details.payload!) as Map<String, dynamic>;

        // Extract message and phone number from the new single-birthday payload
        final message = data['greetingMessage'] as String? ?? '';
        final phoneNumber = data['phoneNumber'] as String? ?? '';

        if (message.isNotEmpty) {
          // Construct WhatsApp URL with or without phone number
          final String whatsappUrl;
          if (phoneNumber.isNotEmpty) {
            // Direct to specific contact
            whatsappUrl =
                'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
          } else {
            // Let user choose contact
            whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
          }

          final uri = Uri.parse(whatsappUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      } catch (e) {
        // Handle error silently
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
  // If notification payload exists, system handles it.
  // Unless user wants to override (not recommended to duplicate).
  // But user specifically wants buttons, which system notification destroys in background.
  // To get buttons in background, one MUST use Data Messages.
  // If we receive a Data Message (notification: null), we show it manually.

  if (message.notification == null) {
    // Initialize for background isolation if needed?
    // Actually FlutterLocalNotificationsPlugin can be used directly.
    await FirebaseNotificationService.showNotification(message);
  }
}
