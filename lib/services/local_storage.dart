import 'dart:convert';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:linkpharma/config/global.dart';

enum LocalStorageKeys { remeberLogin }

class LocalStorage {
  final GetSecureStorage _box = GetSecureStorage(container: 'linkpharma');
  static final LocalStorage I = LocalStorage._();
  LocalStorage._();

  Future<void> init() async {
    await GetSecureStorage.init(container: "linkpharma");
    logger.i("LocalStorage initialized");
  }

  Future<void> setValue<T>(LocalStorageKeys key, T value) async {
    try {
      await _box.write(key.name, value);
    } catch (e) {
      logger.e("Something went wrong in setValue: $e");
    }
  }

  T getValue<T>(LocalStorageKeys key, [T? defaultValue]) {
    final value = _box.read<T>(key.name);
    return value ?? defaultValue as T;
  }

  Future<void> setJson(LocalStorageKeys key, Map<String, dynamic> value) async {
    try {
      if (value.isEmpty) {
        await _box.remove(key.name);
        return;
      }
      await _box.write(key.name, jsonEncode(value));
    } catch (e) {
      logger.e("Something went wrong in setJson: $e");
    }
  }

  Map<String, dynamic> getJson(LocalStorageKeys key) {
    try {
      final String? raw = _box.read<String>(key.name);
      if (raw == null) return {};
      final Map<String, dynamic> jsonMap = jsonDecode(raw);
      return jsonMap;
    } catch (e) {
      logger.e("Something went wrong in getJson: $e");
    }
    return {};
  }

  Future<void> setList<T>(LocalStorageKeys key, List<T> list) async {
    try {
      if (list.isEmpty) {
        await _box.remove(key.name);
        return;
      }
      final firstElement = list.first;
      if (firstElement is int ||
          firstElement is String ||
          firstElement is bool ||
          firstElement is double ||
          firstElement is num) {
        await _box.write(key.name, jsonEncode(list));
      } else if (firstElement is Map<String, dynamic>) {
        await _box.write(key.name, jsonEncode(list));
      } else if (firstElement is List) {
        await _box.write(key.name, jsonEncode(list));
      } else {
        logger.w("Unknow List Type");
      }
    } catch (e) {
      logger.e("Something went wrong in setList: $e");
    }
  }

  List<T> getList<T>(LocalStorageKeys key) {
    try {
      final String? raw = _box.read<String>(key.name);
      if (raw == null || raw.isEmpty) return [];

      final dynamic decoded = jsonDecode(raw);

      if (decoded is! List) {
        logger.w("Stored value is not a list for key: ${key.name}");
        return [];
      }
      if (T == int) {
        return decoded.cast<int>() as List<T>;
      } else if (T == String) {
        return decoded.cast<String>() as List<T>;
      } else if (T == bool) {
        return decoded.cast<bool>() as List<T>;
      } else if (T == double) {
        return decoded.cast<double>() as List<T>;
      } else if (T == num) {
        return decoded.cast<num>() as List<T>;
      } else if (T == Map<String, dynamic>) {
        return decoded.cast<Map<String, dynamic>>() as List<T>;
      } else {
        return decoded.cast<dynamic>() as List<T>;
      }
    } catch (e) {
      logger.e("Something went wrong in getList: $e");
    }
    return [];
  }

  Future<void> remove(LocalStorageKeys key) async {
    await _box.remove(key.name);
  }

  Future<void> clear() async {
    await _box.erase();
  }
}
