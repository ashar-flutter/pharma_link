import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';

class OnlineStatusManager {
  static final OnlineStatusManager _instance = OnlineStatusManager._();
  factory OnlineStatusManager() => _instance;
  OnlineStatusManager._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _onlineTimer;

  Future<void> startOnlineTracking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _onlineTimer?.cancel();

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Online status error: $e');
      }
    }

    _onlineTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await _firestore.collection('users').doc(currentUser.uid).update({
            'lastSeen': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Heartbeat error: $e');
        }
      }
    });
  }

  Future<void> stopOnlineTracking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    _onlineTimer?.cancel();

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Offline status error: $e');
      }
    }
  }

  bool checkIfUserIsOnline(Map<String, dynamic>? userData) {
    if (userData == null) return false;

    final isOnline = userData['isOnline'] ?? false;
    final lastSeen = userData['lastSeen'] as Timestamp?;

    if (!isOnline) return false;

    if (lastSeen != null) {
      final lastSeenTime = lastSeen.toDate();
      final now = DateTime.now();
      final difference = now.difference(lastSeenTime).inSeconds;

      return difference < 60;
    }

    return false;
  }

  void dispose() {
    _onlineTimer?.cancel();
  }
}