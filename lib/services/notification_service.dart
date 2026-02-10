import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> initialize() async {
    try {
      if (kDebugMode) {
        print('NotificationService: Initializing...');
      }
      await _fcm.requestPermission(alert: true, badge: true, sound: true);

      final token = await _fcm.getToken();
      if (kDebugMode) {
        print('FCM Token: $token');
      }

      await _setupLocalNotifications();

      if (kDebugMode) {
        print('NotificationService: Initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService Error: $e');
      }
    }
  }

  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings darwinSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: darwinSettings);

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (kDebugMode) {
          print('Notification tapped: ${response.payload}');
        }
      },
    );

    if (kDebugMode) {
      print('Local notifications initialized');
    }
  }

  Future<void> _saveToFirestoreFromFCM(RemoteMessage message) async {
    if (_currentUserId.isEmpty) return;

    try {
      final title = message.notification?.title ?? message.data['title'];
      final body = message.notification?.body ?? message.data['body'];

      if (title == null || body == null) return;

      final docId = DateTime.now().millisecondsSinceEpoch.toString();

      await _firestore
          .collection('user_notifications')
          .doc(_currentUserId)
          .collection('notifications')
          .doc(docId)
          .set({
            'title': title,
            'description': body,
            'timestamp': FieldValue.serverTimestamp(),
            'isRead': false,
            'type': message.data['type'] ?? 'system',
            'data': message.data,
            'createdAt': FieldValue.serverTimestamp(),
          });

      if (kDebugMode) {
        print('In-app notification saved for user: $_currentUserId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firestore save error: $e');
      }
    }
  }
  Future<void> _showLocalNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'linkpharma_channel',
          'LinkPharma',
          channelDescription: 'LinkPharma notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _localNotifications.show(
      id: id,
      title: message.notification!.title,
      body: message.notification!.body,
      notificationDetails: notificationDetails,
      payload: 'some_payload_if_needed',
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print('Background: ${message.notification?.title}');
    }
  }

  Future<void> clearAll() async {
    await _localNotifications.cancelAll();
  }
}
