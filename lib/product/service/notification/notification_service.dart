/// Interface for notification services.
abstract interface class INotificationService {
  /// Initializes the notification service.
  Future<void> initialize();

  /// Requests permission for notifications.
  Future<void> requestPermission();

  /// Gets the current FCM token.
  Future<String?> getToken();

  /// Stream of token refreshes.
  Stream<String> get onTokenRefresh;

  /// Subscribes to a topic.
  Future<void> subscribeToTopic(String topic);

  /// Unsubscribes from a topic.
  Future<void> unsubscribeFromTopic(String topic);
}
