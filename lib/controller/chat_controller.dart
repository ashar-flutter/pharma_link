import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/models/chat_model.dart';
import 'package:linkpharma/services/firestorage_services.dart';
import 'package:flutter/material.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestorageServices _storage = FirestorageServices.I;
  final ImagePicker _picker = ImagePicker();

  List<ChatConversation> _conversations = [];
  List<ChatMessage> _messages = [];
  final Map<String, StreamSubscription> _messageListeners = {};
  final Map<String, StreamSubscription> _onlineListeners = {};
  StreamSubscription? _convListener;
  String _searchText = '';

  final Map<String, Map<String, String>> _userInfoCache = {};

  String? _receiverId;
  String? _receiverName;
  String? _receiverImage;
  bool _receiverOnline = false;

  List<ChatConversation> get conversations => _conversations;
  List<ChatMessage> get messages => _messages;
  bool get receiverOnline => _receiverOnline;

  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? currentUser.id;
  String get _currentUserName => "${currentUser.firstName} ${currentUser.lastName}";
  String get _currentUserImage => currentUser.image;

  @override
  void onInit() {
    super.onInit();
    if (_currentUserId.isNotEmpty) {
      _loadConversations();
      _startRealTimeListeners();
    }
  }

  @override
  void onClose() {
    for (var sub in _messageListeners.values) {
      sub.cancel();
    }
    for (var sub in _onlineListeners.values) {
      sub.cancel();
    }
    _convListener?.cancel();
    super.onClose();
  }

  void _startRealTimeListeners() {
    _convListener = _firestore
        .collection('conversations')
        .where('user1Id', isEqualTo: _currentUserId)
        .snapshots()
        .listen(_updateConversations);

    _firestore
        .collection('conversations')
        .where('user2Id', isEqualTo: _currentUserId)
        .snapshots()
        .listen(_updateConversations);
  }

  void _updateConversations(QuerySnapshot snapshot) {
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final convId = data['conversationId'] ?? doc.id;

      final index = _conversations.indexWhere((c) => c.conversationId == convId);

      if (index != -1) {
        final unread = data['unreadCount_$_currentUserId'] ?? 0;
        final lastMsgData = data['lastMessage'] as Map<String, dynamic>? ?? {};

        final existing = _conversations[index];

        _conversations[index] = ChatConversation(
          conversationId: convId,
          user1Id: existing.user1Id,
          user1Name: existing.user1Name,
          user1Image: existing.user1Image,
          user2Id: existing.user2Id,
          user2Name: existing.user2Name,
          user2Image: existing.user2Image,
          lastMessage: ChatMessage.fromJson(lastMsgData),
          lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
          unreadCount: unread,
          currentUserId: _currentUserId,
        );
      }
    }

    _conversations.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    update(['inbox']);
  }

  Future<Map<String, String>> _getUserInfoWithCache(String userId) async {
    // Cache check
    if (_userInfoCache.containsKey(userId)) {
      return _userInfoCache[userId]!;
    }

    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();

        String image = '';
        String name = '';

        // Vendor check
        if (data?['owners'] != null && (data?['owners'] as List).isNotEmpty) {
          final owner = (data?['owners'] as List)[0] as Map<String, dynamic>;
          image = owner['image']?.toString() ?? '';
          name = owner['name']?.toString() ??
              '${owner['name']?.toString() ?? ''} ${owner['sureName']?.toString() ?? ''}';
          name = name.trim();
        }
        // Regular user
        else {
          image = data?['image']?.toString() ?? '';
          name = data?['name']?.toString() ??
              '${data?['firstName']?.toString() ?? ''} ${data?['lastName']?.toString() ?? ''}';
          name = name.trim();
        }

        final info = {
          'image': image,
          'name': name.isNotEmpty ? name : 'Unknown User',
        };

        _userInfoCache[userId] = info;
        return info;
      }
    } catch (_) {}

    final fallback = {
      'image': '',
      'name': 'Unknown User',
    };

    _userInfoCache[userId] = fallback;
    return fallback;
  }

  Future<void> _loadConversations() async {
    try {
      final userId = _currentUserId;
      final query1 = await _firestore.collection('conversations').where('user1Id', isEqualTo: userId).get();
      final query2 = await _firestore.collection('conversations').where('user2Id', isEqualTo: userId).get();

      List<ChatConversation> allConvs = [];

      for (var doc in [...query1.docs, ...query2.docs]) {
        final data = doc.data();
        final u1 = data['user1Id']?.toString() ?? '';
        final u2 = data['user2Id']?.toString() ?? '';
        final otherId = u1 == userId ? u2 : u1;

        final otherInfo = await _getUserInfoWithCache(otherId);
        final otherImage = otherInfo['image'] ?? '';
        final otherName = otherInfo['name'] ?? '';

        // Current user info (cache se ya direct)
        final currentInfo = await _getUserInfoWithCache(userId);
        final currentImage = currentInfo['image']?.isNotEmpty == true
            ? currentInfo['image']!
            : _currentUserImage;
        final currentName = currentInfo['name']?.isNotEmpty == true
            ? currentInfo['name']!
            : _currentUserName;

        final convData = {
          'conversationId': data['conversationId'] ?? doc.id,
          'user1Id': u1,
          'user1Name': u1 == userId ? currentName : otherName,
          'user1Image': u1 == userId ? currentImage : otherImage,
          'user2Id': u2,
          'user2Name': u2 == userId ? currentName : otherName,
          'user2Image': u2 == userId ? currentImage : otherImage,
          'lastMessage': data['lastMessage'] ?? {},
          'lastMessageTime': data['lastMessageTime'] ?? Timestamp.now(),
          'unreadCount': data['unreadCount_$userId'] ?? 0,
        };

        allConvs.add(ChatConversation.fromJson(convData, userId));
      }

      allConvs.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      _conversations = allConvs;
      update(['inbox']);
    } catch (_) {
      _conversations = [];
      update(['inbox']);
    }
  }

  Future<void> openChat(String id, String name, String image, String? role) async {
    _receiverId = id;
    _receiverName = name;
    _receiverImage = image;
    _receiverOnline = false;

    update(['header']);

    _messages.clear();
    update(['messages']);

    await _loadMessages(id);
    await _startMessagesListener(id);
    await _markAsRead(id);
    await _startOnlineStatusListener(id);
  }

  Future<void> _startOnlineStatusListener(String otherId) async {
    if (_onlineListeners.containsKey(otherId)) {
      _onlineListeners[otherId]!.cancel();
    }

    final subscription = _firestore
        .collection('users')
        .doc(otherId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final isOnline = data['isOnline'] ?? false;

        _receiverOnline = isOnline;
        update(['header']);
      }
    });

    _onlineListeners[otherId] = subscription;
  }

  Future<void> _loadMessages(String otherId) async {
    try {
      final convId = _getConvId(_currentUserId, otherId);
      final snapshot = await _firestore
          .collection('conversations')
          .doc(convId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();

      _messages = snapshot.docs
          .map((doc) => ChatMessage.fromJson(doc.data()))
          .toList();
      update(['messages']);
    } catch (_) {
      _messages = [];
      update(['messages']);
    }
  }

  Future<void> _startMessagesListener(String otherId) async {
    final convId = _getConvId(_currentUserId, otherId);

    if (_messageListeners.containsKey(convId)) {
      _messageListeners[convId]!.cancel();
    }

    final subscription = _firestore
        .collection('conversations')
        .doc(convId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      _messages = snapshot.docs
          .map((doc) => ChatMessage.fromJson(doc.data()))
          .toList();
      update(['messages']);
    });

    _messageListeners[convId] = subscription;
  }

  Future<void> _markAsRead(String otherId) async {
    try {
      final convId = _getConvId(_currentUserId, otherId);
      await _firestore.collection('conversations').doc(convId).update({
        'unreadCount_$_currentUserId': 0,
      });

      final index = _conversations.indexWhere((c) => c.conversationId == convId);
      if (index != -1) {
        _conversations[index] = ChatConversation(
          conversationId: convId,
          user1Id: _conversations[index].user1Id,
          user1Name: _conversations[index].user1Name,
          user1Image: _conversations[index].user1Image,
          user2Id: _conversations[index].user2Id,
          user2Name: _conversations[index].user2Name,
          user2Image: _conversations[index].user2Image,
          lastMessage: _conversations[index].lastMessage,
          lastMessageTime: _conversations[index].lastMessageTime,
          unreadCount: 0,
          currentUserId: _currentUserId,
        );
        update(['inbox']);
      }
    } catch (_) {}
  }

  String _getConvId(String u1, String u2) {
    final ids = [u1, u2]..sort();
    return "${ids[0]}_${ids[1]}";
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty || _receiverId == null) return;

    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    final messageData = ChatMessage(
      id: messageId,
      senderId: _currentUserId,
      senderName: _currentUserName,
      receiverId: _receiverId!,
      receiverName: _receiverName!,
      message: text,
      messageType: 'text',
      timestamp: now,
      isRead: false,
    );

    _messages.add(messageData);
    update(['messages']);

    try {
      final convId = _getConvId(_currentUserId, _receiverId!);
      final users = [_currentUserId, _receiverId!]..sort();
      final isUser1 = users[0] == _currentUserId;

      final conversationData = {
        'conversationId': convId,
        'user1Id': users[0],
        'user1Name': isUser1 ? _currentUserName : _receiverName!,
        'user1Image': isUser1 ? _currentUserImage : (_receiverImage ?? ''),
        'user2Id': users[1],
        'user2Name': isUser1 ? _receiverName! : _currentUserName,
        'user2Image': isUser1 ? (_receiverImage ?? '') : _currentUserImage,
        'lastMessage': messageData.toJson(),
        'lastMessageTime': Timestamp.fromDate(now),
        'unreadCount_$_currentUserId': 0,
        'unreadCount_$_receiverId': FieldValue.increment(1),
      };

      final batch = _firestore.batch();
      final convRef = _firestore.collection('conversations').doc(convId);
      batch.set(convRef, conversationData, SetOptions(merge: true));
      batch.set(convRef.collection('messages').doc(messageId), messageData.toJson());
      await batch.commit();

    } catch (_) {
      if (_messages.isNotEmpty && _messages.last.id == messageId) {
        _messages.removeLast();
        update(['messages']);
      }
    }
  }

  Future<void> sendImage() async {
    if (_receiverId == null) return;

    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final url = await _storage.uploadImage(File(image.path), 'chat_images');
    if (url.isEmpty) return;

    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    final imageMessage = ChatMessage(
      id: messageId,
      senderId: _currentUserId,
      senderName: _currentUserName,
      receiverId: _receiverId!,
      receiverName: _receiverName!,
      message: "📷 Image",
      messageType: 'image',
      timestamp: now,
      isRead: false,
      fileUrl: url,
    );

    _messages.add(imageMessage);
    update(['messages']);

    try {
      final convId = _getConvId(_currentUserId, _receiverId!);
      final users = [_currentUserId, _receiverId!]..sort();
      final isUser1 = users[0] == _currentUserId;

      final conversationData = {
        'conversationId': convId,
        'user1Id': users[0],
        'user1Name': isUser1 ? _currentUserName : _receiverName!,
        'user1Image': isUser1 ? _currentUserImage : (_receiverImage ?? ''),
        'user2Id': users[1],
        'user2Name': isUser1 ? _receiverName! : _currentUserName,
        'user2Image': isUser1 ? (_receiverImage ?? '') : _currentUserImage,
        'lastMessage': imageMessage.toJson(),
        'lastMessageTime': Timestamp.fromDate(now),
        'unreadCount_$_currentUserId': 0,
        'unreadCount_$_receiverId': FieldValue.increment(1),
      };

      final batch = _firestore.batch();
      final convRef = _firestore.collection('conversations').doc(convId);
      batch.set(convRef, conversationData, SetOptions(merge: true));
      batch.set(convRef.collection('messages').doc(messageId), imageMessage.toJson());
      await batch.commit();

    } catch (_) {
      if (_messages.isNotEmpty && _messages.last.id == messageId) {
        _messages.removeLast();
        update(['messages']);
      }
    }
  }

  void closeChat() {
    for (var sub in _messageListeners.values) {
      sub.cancel();
    }
    for (var sub in _onlineListeners.values) {
      sub.cancel();
    }
    _messageListeners.clear();
    _onlineListeners.clear();
    _messages.clear();
    _receiverId = null;
    _receiverName = null;
    _receiverImage = null;
    _receiverOnline = false;
    update(['messages']);
  }

  List<ChatConversation> get filteredConvs {
    if (_searchText.isEmpty) return _conversations;
    return _conversations.where((conv) {
      return conv.otherUserName.toLowerCase().contains(_searchText.toLowerCase()) ||
          conv.lastMessage.message.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }

  void updateSearch(String text) {
    _searchText = text;
    update(['inbox']);
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(time.year, time.month, time.day);

    if (msgDate.isAtSameMomentAs(today)) {
      final hour = time.hour > 12 ? time.hour - 12 : time.hour == 0 ? 12 : time.hour;
      final minute = time.minute.toString().padLeft(2, '0');
      final ampm = time.hour >= 12 ? 'PM' : 'AM';
      return "$hour:$minute $ampm";
    }
    return "${time.day}/${time.month}";
  }


  void scrollToBottom(ScrollController controller) {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }



}