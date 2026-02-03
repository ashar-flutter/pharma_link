// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:linkpharma/models/chat_model.dart';
//
// class ChatFirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   static final ChatFirestoreService I = ChatFirestoreService._();
//   ChatFirestoreService._();
//
//   String _convId(String u1, String u2) {
//     List<String> ids = [u1, u2]..sort();
//     return "${ids[0]}_${ids[1]}";
//   }
//
//   Stream<List<ChatConversation>> getUserConversationsStream(String userId) {
//     return _firestore.collection('conversations').snapshots().asyncMap((
//       snapshot,
//     ) async {
//       List<ChatConversation> convs = [];
//
//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         final u1 = data['user1Id'] ?? '';
//         final u2 = data['user2Id'] ?? '';
//
//         if (u1 == userId || u2 == userId) {
//           final unread = data['unreadCount_$userId'] ?? 0;
//           final otherId = u1 == userId ? u2 : u1;
//
//           try {
//             final otherDoc = await _firestore
//                 .collection('users')
//                 .doc(otherId)
//                 .get();
//             final otherData = otherDoc.data();
//             final otherImage = otherData?['image'] ?? '';
//
//             final updatedData = Map<String, dynamic>.from(data);
//
//             updatedData['conversationId'] = data['conversationId'] ?? doc.id;
//
//             if (u1 == userId) {
//               updatedData['user2Image'] = otherImage;
//             } else {
//               updatedData['user1Image'] = otherImage;
//             }
//
//             updatedData['unreadCount'] = unread;
//
//             final conv = ChatConversation.fromJson(updatedData, userId);
//             convs.add(conv);
//           } catch (_) {}
//         }
//       }
//
//       convs.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
//
//       return convs;
//     });
//   }
//
//   Stream<List<ChatMessage>> getMessagesStream(String u1, String u2) {
//     return _firestore
//         .collection('conversations')
//         .doc(_convId(u1, u2))
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .map(
//           (snap) =>
//               snap.docs.map((d) => ChatMessage.fromJson(d.data())).toList(),
//         );
//   }
//
//   Future<void> sendMessage({
//     required String senderId,
//     required String senderName,
//     required String senderImage,
//     required String receiverId,
//     required String receiverName,
//     required String message,
//     String messageType = 'text',
//     String? fileUrl,
//   }) async {
//     try {
//       final convId = _convId(senderId, receiverId);
//       final msgId = DateTime.now().millisecondsSinceEpoch.toString();
//       final now = DateTime.now();
//
//       final msgData = {
//         'id': msgId,
//         'senderId': senderId,
//         'senderName': senderName,
//         'receiverId': receiverId,
//         'receiverName': receiverName,
//         'message': message,
//         'messageType': messageType,
//         'timestamp': Timestamp.fromDate(now),
//         'isRead': false,
//         if (fileUrl != null) 'fileUrl': fileUrl,
//       };
//
//       await _firestore
//           .collection('conversations')
//           .doc(convId)
//           .collection('messages')
//           .doc(msgId)
//           .set(msgData);
//
//       final users = [senderId, receiverId]..sort();
//       final senderFirst = users[0] == senderId;
//
//       await _firestore.collection('conversations').doc(convId).set({
//         'conversationId': convId,
//         'user1Id': users[0],
//         'user1Name': senderFirst ? senderName : receiverName,
//         'user1Image': senderFirst ? senderImage : '',
//         'user2Id': users[1],
//         'user2Name': senderFirst ? receiverName : senderName,
//         'user2Image': senderFirst ? '' : senderImage,
//         'lastMessage': msgData,
//         'lastMessageTime': Timestamp.fromDate(now),
//         'updatedAt': FieldValue.serverTimestamp(),
//         'unreadCount_$senderId': 0,
//         'unreadCount_$receiverId': FieldValue.increment(1),
//       }, SetOptions(merge: true));
//     } catch (_) {}
//   }
//
//   Future<void> markAsRead(String userId, String otherId) async {
//     try {
//       await _firestore
//           .collection('conversations')
//           .doc(_convId(userId, otherId))
//           .update({'unreadCount_$userId': 0});
//     } catch (_) {}
//   }
// }
