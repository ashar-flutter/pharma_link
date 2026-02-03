import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _conversationsKey = 'chat_conversations';

  Future<void> saveConversations(String userId, List<Map<String, dynamic>> conversations) async {
    try {
      final key = '$_conversationsKey-$userId';
      final jsonString = json.encode(conversations);
      await _storage.write(key: key, value: jsonString);
    } catch (_) {}
  }

  Future<List<Map<String, dynamic>>> loadConversations(String userId) async {
    try {
      final key = '$_conversationsKey-$userId';
      final jsonString = await _storage.read(key: key);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  Future<void> clearUserData(String userId) async {
    try {
      final key = '$_conversationsKey-$userId';
      await _storage.delete(key: key);
    } catch (_) {}
  }
}