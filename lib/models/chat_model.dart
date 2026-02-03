import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String id;
  String senderId;
  String senderName;
  String receiverId;
  String receiverName;
  String message;
  String messageType;
  DateTime timestamp;
  bool isRead;
  String? fileUrl;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.message,
    this.messageType = 'text',
    required this.timestamp,
    this.isRead = false,
    this.fileUrl,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'] ?? '',
      message: json['message'] ?? '',
      messageType: json['messageType'] ?? 'text',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      isRead: json['isRead'] ?? false,
      fileUrl: json['fileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'message': message,
      'messageType': messageType,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'fileUrl': fileUrl,
    };
  }
}

class ChatConversation {
  String conversationId;
  String user1Id;
  String user1Name;
  String user1Image;
  String user2Id;
  String user2Name;
  String user2Image;
  ChatMessage lastMessage;
  DateTime lastMessageTime;
  int unreadCount;
  String currentUserId;

  ChatConversation({
    required this.conversationId,
    required this.user1Id,
    required this.user1Name,
    required this.user1Image,
    required this.user2Id,
    required this.user2Name,
    required this.user2Image,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.currentUserId,
  });

  String get otherUserId => currentUserId == user1Id ? user2Id : user1Id;
  String get otherUserName => currentUserId == user1Id ? user2Name : user1Name;
  String get otherUserImage => currentUserId == user1Id ? user2Image : user1Image;

  factory ChatConversation.fromJson(Map<String, dynamic> json, String currentUserId) {
    return ChatConversation(
      conversationId: json['conversationId'] ?? '',
      user1Id: json['user1Id'] ?? '',
      user1Name: json['user1Name'] ?? '',
      user1Image: json['user1Image'] ?? '',
      user2Id: json['user2Id'] ?? '',
      user2Name: json['user2Name'] ?? '',
      user2Image: json['user2Image'] ?? '',
      lastMessage: ChatMessage.fromJson(json['lastMessage'] ?? {}),
      lastMessageTime: (json['lastMessageTime'] as Timestamp).toDate(),
      unreadCount: json['unreadCount'] ?? 0,
      currentUserId: currentUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'user1Id': user1Id,
      'user1Name': user1Name,
      'user1Image': user1Image,
      'user2Id': user2Id,
      'user2Name': user2Name,
      'user2Image': user2Image,
      'lastMessage': lastMessage.toJson(),
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unreadCount': unreadCount,
    };
  }
}