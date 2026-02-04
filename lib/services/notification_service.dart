// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//
//   factory NotificationService() => _instance;
//
//   NotificationService._internal();
//
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> initialize() async {
//     try {
//       print('NotificationService: Initializing...');
//
//       // Request iOS permissions
//       await _fcm.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//       );
//
//       // Get FCM token
//       final token = await _fcm.getToken();
//       print('FCM Token: $token');
//
//       // Setup local notifications
//       await _setupLocalNotifications();
//
//       // Setup message handlers
//       _setupMessageHandlers();
//
//       print('NotificationService: Initialized successfully');
//     } catch (e) {
//       print('NotificationService Error: $e');
//     }
//   }
//
//   Future<void> _setupLocalNotifications() async {
//     try {
//       // Android setup
//       const AndroidInitializationSettings androidSettings =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//
//       // iOS setup
//       const DarwinInitializationSettings iosSettings =
//       DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//       );
//
//       // Initialize with NAMED PARAMETER 'settings'
//       final InitializationSettings initSettings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );
//
//       await _localNotifications.initialize(
//         settings: initSettings,
//       );
//
//       print('Local notifications initialized');
//     } catch (e) {
//       print('Local notifications setup error: $e');
//     }
//   }
//
//   void _setupMessageHandlers() {
//     // Foreground message
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Foreground message: ${message.notification?.title}');
//       _showNotification(message);
//     });
//
//     // Background message opened
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Message opened: ${message.notification?.title}');
//       _handleNotificationTap(message);
//     });
//
//     // Background handler
//     FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
//   }
//
//   Future<void> _showNotification(RemoteMessage message) async {
//     if (message.notification == null) return;
//
//     try {
//       const AndroidNotificationDetails androidDetails =
//       AndroidNotificationDetails(
//         'linkpharma_channel',
//         'LinkPharma',
//         channelDescription: 'LinkPharma notifications',
//         importance: Importance.max,
//         priority: Priority.high,
//         showWhen: true,
//       );
//
//       const DarwinNotificationDetails iosDetails =
//       DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );
//
//       final NotificationDetails details = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );
//
//       final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//
//       // show() with NAMED PARAMETERS
//       await _localNotifications.show(
//         id: notificationId,
//         title: message.notification?.title,
//         body: message.notification?.body,
//         notificationDetails: details,
//       );
//
//       print('Notification shown: ID=$notificationId');
//     } catch (e) {
//       print('Show notification error: $e');
//     }
//   }
//
//   void _handleNotificationTap(RemoteMessage message) {
//     print('Notification tapped: ${message.data}');
//     // Handle navigation here
//   }
//
//   @pragma('vm:entry-point')
//   static Future<void> _backgroundHandler(RemoteMessage message) async {
//     print('Background message: ${message.notification?.title}');
//   }
//
//   Future<void> clearAll() async {
//     await _localNotifications.cancelAll();
//   }
// }