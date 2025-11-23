import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling background message: ${message.messageId}');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
  }
}

class NotificationsService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // Initialize notifications
  Future<void> initialize() async {
    try {
      // Request permission
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        print('User granted permission: ${settings.authorizationStatus}');
      }

      // Get FCM token
      _fcmToken = await _messaging.getToken();
      if (kDebugMode) {
        print('FCM Token: $_fcmToken');
      }

      // Listen to token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        if (kDebugMode) {
          print('FCM Token refreshed: $newToken');
        }
        // TODO: Send token to your server
      });

      // Set up foreground message handler
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a notification
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing notifications: $e');
      }
    }
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Received foreground message: ${message.messageId}');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
    }

    // You can show a local notification here or update UI
    // For now, we'll just log it
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification tapped: ${message.messageId}');
      print('Data: ${message.data}');
    }

    // Navigate to specific screen based on notification data
    // Example: if (message.data['type'] == 'rate_alert') { navigate to alerts }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to topic: $e');
      }
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from topic: $e');
      }
    }
  }

  // Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _fcmToken = null;
      if (kDebugMode) {
        print('FCM token deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting token: $e');
      }
    }
  }

  // Send rate alert notification (this would typically be done from backend)
  // This is a placeholder to show the structure
  Map<String, dynamic> createRateAlertNotification({
    required String baseCurrency,
    required String targetCurrency,
    required double currentRate,
    required double threshold,
    required String condition,
  }) {
    return {
      'notification': {
        'title': 'Rate Alert Triggered! 🔔',
        'body':
            '$baseCurrency/$targetCurrency is $condition $threshold (Current: $currentRate)',
      },
      'data': {
        'type': 'rate_alert',
        'baseCurrency': baseCurrency,
        'targetCurrency': targetCurrency,
        'currentRate': currentRate.toString(),
        'threshold': threshold.toString(),
        'condition': condition,
      },
    };
  }
}
