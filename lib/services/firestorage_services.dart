import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

import '../config/global.dart';

class FirestorageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();
  static final FirestorageServices I = FirestorageServices._();
  FirestorageServices._();

  Future<String> uploadImage(File image, String folderName) async {
    try {
      if (!await image.exists()) {
        logger.e("Image file does not exist");
        return "";
      }
      final fileSize = await image.length();
      if (fileSize > 10 * 1024 * 1024) {
        logger.e("Image file is too large (max 10MB)");
        return "";
      }
      final String fileName = '${_uuid.v4()}${path.extension(image.path)}';
      final String filePath = '$folderName/${currentUser.id}/$fileName';
      final Reference storageRef = _storage.ref().child(filePath);
      logger.i(
        "Uploading image: ${path.basename(image.path)} (${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB)",
      );
      final TaskSnapshot snapshot = await storageRef.putFile(
        image,
        SettableMetadata(
          contentType: _getMimeType(image.path),
          customMetadata: {'owner': currentUser.id},
        ),
      );

      final String downloadUrl = await snapshot.ref.getDownloadURL();
      logger.i("✅ Image uploaded successfully: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      logger.e("Error uploading image: $e");
      return "";
    }
  }

  Future<String> uploadFile(File file, String folderName) async {
    try {
      if (!await file.exists()) {
        logger.e("File does not exist");
        return "";
      }
      final fileSize = await file.length();
      if (fileSize > 50 * 1024 * 1024) {
        logger.e("File is too large (max 50MB)");
        return "";
      }
      final String fileName = '${_uuid.v4()}${path.extension(file.path)}';
      final String filePath = '$folderName/${currentUser.id}/$fileName';
      final String? mimeType = _getMimeType(file.path);
      final Reference storageRef = _storage.ref().child(filePath);
      final UploadTask uploadTask = storageRef.putFile(
        file,
        SettableMetadata(
          contentType: mimeType,
          customMetadata: {
            'originalName': path.basename(file.path),
            'uploadedAt': DateTime.now().toIso8601String(),
            'fileSize': fileSize.toString(),
          },
        ),
      );
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        logger.i('File upload progress: ${progress.toStringAsFixed(2)}%');
      });
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      logger.i("File uploaded successfully: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      logger.e("Error uploading file: $e");
      return "";
    }
  }

  Future<String> uploadVideo(File video, String folderName) async {
    try {
      if (!await video.exists()) {
        logger.e("Video file does not exist");
        return "";
      }
      final fileSize = await video.length();
      if (fileSize > 100 * 1024 * 1024) {
        logger.e("Video file is too large (max 100MB)");
        return "";
      }

      final extension = path.extension(video.path).toLowerCase();
      final List<String> allowedExtensions = [
        '.mp4',
        '.mov',
        '.avi',
        '.mkv',
        '.webm',
      ];
      if (!allowedExtensions.contains(extension)) {
        logger.i(
          "Unsupported video format. Allowed: ${allowedExtensions.join(', ')}",
        );
        return "";
      }
      final String fileName = '${_uuid.v4()}$extension';
      final String filePath = '$folderName/${currentUser.id}/$fileName';
      final Reference storageRef = _storage.ref().child(filePath);
      final UploadTask uploadTask = storageRef.putFile(
        video,
        SettableMetadata(
          contentType: _getVideoMimeType(extension),
          customMetadata: {
            'originalName': path.basename(video.path),
            'uploadedAt': DateTime.now().toIso8601String(),
            'fileSize': fileSize.toString(),
            'type': 'video',
          },
        ),
      );
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        logger.i('Video upload progress: ${progress.toStringAsFixed(2)}%');
      });
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      logger.i("Video uploaded successfully: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      logger.e("Error uploading video: $e");
      return "";
    }
  }

  Future<String> deleteFile(String imageURL) async {
    try {
      if (imageURL.isEmpty) {
        return "Invalid URL";
      }
      final Uri uri = Uri.parse(imageURL);
      String filePath = uri.path;
      if (filePath.startsWith('/v0/b/')) {
        final segments = filePath.split('/');
        if (segments.length > 4) {
          filePath = segments.sublist(4).join('/');
        }
      }
      final Reference storageRef = _storage.ref().child(filePath);
      await storageRef.delete();
      logger.i("File deleted successfully: $filePath");
      return "Success";
    } on FirebaseException catch (e) {
      logger.e("Firebase error deleting file: $e");
      if (e.code == 'object-not-found') {
        return "File not found";
      }
      if (e.code == 'unauthorized' || e.code == 'permission-denied') {
        return "Permission denied";
      }
      return "Error: ${e.code}";
    } catch (e) {
      logger.e("Error deleting file: $e");
      return "Error: $e";
    }
  }

  String? _getMimeType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    final Map<String, String> mimeTypes = {
      '.jpg': 'image/jpeg',
      '.jpeg': 'image/jpeg',
      '.png': 'image/png',
      '.gif': 'image/gif',
      '.bmp': 'image/bmp',
      '.webp': 'image/webp',
      '.svg': 'image/svg+xml',
      '.pdf': 'application/pdf',
      '.doc': 'application/msword',
      '.docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      '.xls': 'application/vnd.ms-excel',
      '.xlsx':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      '.ppt': 'application/vnd.ms-powerpoint',
      '.pptx':
          'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      '.txt': 'text/plain',
      '.zip': 'application/zip',
      '.rar': 'application/x-rar-compressed',
      '.mp3': 'audio/mpeg',
      '.wav': 'audio/wav',
      '.mp4': 'video/mp4',
      '.mov': 'video/quicktime',
      '.avi': 'video/x-msvideo',
    };
    return mimeTypes[extension];
  }

  String? _getVideoMimeType(String extension) {
    final Map<String, String> videoMimeTypes = {
      '.mp4': 'video/mp4',
      '.mov': 'video/quicktime',
      '.avi': 'video/x-msvideo',
      '.mkv': 'video/x-matroska',
      '.webm': 'video/webm',
      '.wmv': 'video/x-ms-wmv',
      '.flv': 'video/x-flv',
    };
    return videoMimeTypes[extension];
  }
}
