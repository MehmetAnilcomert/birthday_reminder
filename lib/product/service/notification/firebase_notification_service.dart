import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:birthday_reminder/product/init/language/locale_keys.g.dart';
import 'package:birthday_reminder/product/service/notification/notification_service.dart';
import 'package:birthday_reminder/product/services/encryption_service.dart';
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
      settings: initSettings,
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

    // Check if the app was launched from a notification (Terminated State)
    final launchDetails = await _localNotifications
        .getNotificationAppLaunchDetails();
    if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
      if (launchDetails.notificationResponse != null) {
        // Delay slightly to ensure app state/router is ready
        unawaited(
          Future.delayed(const Duration(seconds: 1), () {
            _handleNotificationResponse(launchDetails.notificationResponse!);
          }),
        );
      }
    }

    // Handle background to foreground transition via FCM (if notification clicked)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // If we handle notifications manually via local notifications,
      // this might be redundant, but good to have for direct FCM notifications.
      showNotification(message);
    });

    // Check for initial message (if app was terminated and opened via FCM directly)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      showNotification(initialMessage);
    }
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
      // Fallback for background translation since easy_localization might not be ready
      String actionTitle = 'Tebrik mesajı gönder'; // Default Turkish
      try {
        actionTitle = LocaleKeys.send_wish.tr();
        if (actionTitle == LocaleKeys.send_wish) {
          // If translation failed (it returns the key), use fallback
          actionTitle = 'Tebrik mesajı gönder';
        }
      } catch (e) {
        actionTitle = 'Tebrik mesajı gönder';
      }

      await flutterLocalNotificationsPlugin.show(
        id: message.hashCode,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
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
                actionTitle,
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
        final encryptionService = EncryptionService();

        // Extract encrypted data and credentials from payload
        final encGreeting = data['encryptedGreetingMessage'] as String? ?? '';
        final encPhone = data['encryptedPhoneNumber'] as String? ?? '';
        final userId = data['userId'] as String? ?? '';
        final userEmail = data['userEmail'] as String? ?? '';
        final birthdayId = data['birthdayId'] as String? ?? '';

        String message = '';
        String phoneNumber = '';

        if (userId.isNotEmpty && userEmail.isNotEmpty) {
          try {
            message = await encryptionService.decryptString(
              encGreeting,
              userId,
              userEmail,
            );
            phoneNumber = await encryptionService.decryptString(
              encPhone,
              userId,
              userEmail,
            );
          } catch (e) {
            // Check if backend sent plaintext as fallback
            message = data['greetingMessage'] as String? ?? '';
            phoneNumber = data['phoneNumber'] as String? ?? '';
          }
        } else {
          // Fallback to plaintext if credentials are missing
          message = data['greetingMessage'] as String? ?? '';
          phoneNumber = data['phoneNumber'] as String? ?? '';
        }

        if (message.isNotEmpty) {
          // Clean phone number: remove any non-digit characters
          String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

          // Construct WhatsApp URL
          final String whatsappUrl;
          if (cleanNumber.isNotEmpty) {
            if (cleanNumber.startsWith('0')) {
              cleanNumber = '90${cleanNumber.substring(1)}';
            }
            whatsappUrl =
                'https://wa.me/$cleanNumber?text=${Uri.encodeComponent(message)}';
          } else {
            whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
          }

          final uri = Uri.parse(whatsappUrl);

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            print('Could not launch WhatsApp URL');
          }
        } else {
          print('Message is empty, cannot redirect');
        }
      } catch (e) {
        print('Error handling notification response: $e');
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
