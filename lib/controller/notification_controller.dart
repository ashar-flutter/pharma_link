import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:linkpharma/models/notification_model.dart';
import 'package:linkpharma/services/firestore_services.dart';

class NotificationController extends GetxController {
  final FirestoreServices _firestore = FirestoreServices.I;

  List<AppNotification> _allNotifications = [];
  List<AppNotification> get allNotifications => _allNotifications;

  List<AppNotification> get unreadNotifications =>
      _allNotifications.where((n) => !n.isRead).toList();

  List<AppNotification> get readNotifications =>
      _allNotifications.where((n) => n.isRead).toList();

  int get unreadCount => unreadNotifications.length;

  StreamSubscription<QuerySnapshot>? _notificationListener;
  bool _isListening = false;

  @override
  void onInit() {
    super.onInit();
    _startListening();
  }

  void _startListening() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || _isListening) return;

    _isListening = true;

    _notificationListener = _firestore.firestore
        .collection('user_notifications')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            _allNotifications = snapshot.docs
                .map((doc) => AppNotification.fromFirestore(doc))
                .toList();

            update(['notifications']);
          },
          onError: (error) {
            if (kDebugMode) {
              print('Notification listener error: $error');
            }
          },
        );
  }

  Future<void> markAsRead(String notificationId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore.markNotificationRead(userId, notificationId);

    final index = _allNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _allNotifications[index] = AppNotification(
        id: _allNotifications[index].id,
        title: _allNotifications[index].title,
        description: _allNotifications[index].description,
        timestamp: _allNotifications[index].timestamp,
        isRead: true,
        type: _allNotifications[index].type,
        data: _allNotifications[index].data,
      );
      update(['notifications']);
    }
  }

  Future<void> markAllAsRead() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    for (var notification in unreadNotifications) {
      await _firestore.markNotificationRead(userId, notification.id);
    }

    update(['notifications']);
  }

  @override
  void onClose() {
    _notificationListener?.cancel();
    _isListening = false;
    super.onClose();
  }
}
