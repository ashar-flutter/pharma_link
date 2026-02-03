import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/models/chat_model.dart';
import 'package:linkpharma/services/firestorage_services.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestorageServices _storage = FirestorageServices.I;
  final ImagePicker _picker = ImagePicker();

  List<ChatConversation> _conversations = [];
  List<ChatMessage> _messages = [];
  final Map<String, StreamSubscription> _messageListeners = {};
  StreamSubscription? _convListener;
  String _searchText = '';

  String? _receiverId;
  String? _receiverName;
  String? _receiverImage;

  // ✅ Minimal safe fix for receiverOnline
  bool receiverOnline = false;
  bool get isReceiverOnline => receiverOnline;

  List<ChatConversation> get conversations => _conversations;
  List<ChatMessage> get messages => _messages;

  String get _currentUserId =>
      FirebaseAuth.instance.currentUser?.uid ?? currentUser.id;
  String get _currentUserName =>
      "${currentUser.firstName} ${currentUser.lastName}";
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

      final index = _conversations.indexWhere(
        (c) => c.conversationId == convId,
      );

      if (index != -1) {
        final unread = data['unreadCount_$_currentUserId'] ?? 0;
        final lastMsgData = data['lastMessage'] as Map<String, dynamic>? ?? {};

        _conversations[index] = ChatConversation(
          conversationId: convId,
          user1Id: data['user1Id']?.toString() ?? '',
          user1Name: data['user1Name']?.toString() ?? '',
          user1Image: data['user1Image']?.toString() ?? '',
          user2Id: data['user2Id']?.toString() ?? '',
          user2Name: data['user2Name']?.toString() ?? '',
          user2Image: data['user2Image']?.toString() ?? '',
          lastMessage: ChatMessage.fromJson(lastMsgData),
          lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
          unreadCount: unread,
          currentUserId: _currentUserId,
        );
      }
    }

    _conversations.sort(
      (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
    );
    update(['inbox']);
  }

  Future<void> _loadConversations() async {
    try {
      final userId = _currentUserId;
      final query1 = await _firestore
          .collection('conversations')
          .where('user1Id', isEqualTo: userId)
          .get();
      final query2 = await _firestore
          .collection('conversations')
          .where('user2Id', isEqualTo: userId)
          .get();

      List<ChatConversation> allConvs = [];

      for (var doc in [...query1.docs, ...query2.docs]) {
        final data = doc.data();
        final u1 = data['user1Id']?.toString() ?? '';
        final u2 = data['user2Id']?.toString() ?? '';
        final otherId = u1 == userId ? u2 : u1;

        String otherImage = '';
        String otherName = '';

        try {
          final otherDoc = await _firestore
              .collection('users')
              .doc(otherId)
              .get();
          if (otherDoc.exists) {
            final otherData = otherDoc.data();
            otherImage = otherData?['image']?.toString() ?? '';
            otherName =
                otherData?['name']?.toString() ??
                '${otherData?['firstName']?.toString() ?? ''} ${otherData?['lastName']?.toString() ?? ''}';
            otherName = otherName.trim();
          }
        } catch (_) {
          otherImage = u1 == userId
              ? (data['user2Image']?.toString() ?? '')
              : (data['user1Image']?.toString() ?? '');
          otherName = u1 == userId
              ? (data['user2Name']?.toString() ?? '')
              : (data['user1Name']?.toString() ?? '');
        }

        final convData = {
          'conversationId': data['conversationId'] ?? doc.id,
          'user1Id': u1,
          'user1Name': u1 == userId ? _currentUserName : otherName,
          'user1Image': u1 == userId ? _currentUserImage : otherImage,
          'user2Id': u2,
          'user2Name': u2 == userId ? _currentUserName : otherName,
          'user2Image': u2 == userId ? _currentUserImage : otherImage,
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

  Future<void> openChat(
    String id,
    String name,
    String image,
    String? role,
  ) async {
    _receiverId = id;
    _receiverName = name;
    _receiverImage = image;

    _messages.clear();
    update(['messages']);

    await _loadMessages(id);
    await _startMessagesListener(id);
    await _markAsRead(id);

    receiverOnline = false;
    update(['header']);
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

      final index = _conversations.indexWhere(
        (c) => c.conversationId == convId,
      );
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
      batch.set(
        convRef.collection('messages').doc(messageId),
        messageData.toJson(),
      );
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
      batch.set(
        convRef.collection('messages').doc(messageId),
        imageMessage.toJson(),
      );
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
    _messageListeners.clear();
    _messages.clear();
    _receiverId = null;
    _receiverName = null;
    _receiverImage = null;
    update(['messages']);
  }

  List<ChatConversation> get filteredConvs {
    if (_searchText.isEmpty) return _conversations;
    return _conversations.where((conv) {
      return conv.otherUserName.toLowerCase().contains(
            _searchText.toLowerCase(),
          ) ||
          conv.lastMessage.message.toLowerCase().contains(
            _searchText.toLowerCase(),
          );
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
      final hour = time.hour > 12
          ? time.hour - 12
          : time.hour == 0
          ? 12
          : time.hour;
      final minute = time.minute.toString().padLeft(2, '0');
      final ampm = time.hour >= 12 ? 'PM' : 'AM';
      return "$hour:$minute $ampm";
    }
    return "${time.day}/${time.month}";
  }
}
