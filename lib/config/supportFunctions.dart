import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:croppy/croppy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class SupportFunctions {
  static final SupportFunctions I = SupportFunctions._();
  SupportFunctions._();

  Future<void> launchLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<List<File>?> getImages({
    required BuildContext context,
    int maxCount = 1,
    RequestType requestType = RequestType.image,
    bool showCamera = true,
    bool isCircleCrop = false,
  }) async {
    assert(maxCount >= 1, 'maxCount must be at least 1');
    final bool isSingle = maxCount == 1;

    final List<SpecialItem<AssetPathEntity>> specialItems = showCamera
        ? [
      SpecialItem(
        position: SpecialItemPosition.prepend,
        builder:
            (
            BuildContext context,
            AssetPathEntity? path,
            PermissionState ps,
            ) {
          return GestureDetector(
            onTap: () async {
              final AssetEntity? entity =
              await CameraPicker.pickFromCamera(
                context,
                pickerConfig: CameraPickerConfig(
                  enableRecording: false,
                  theme: ThemeData(
                    colorScheme: ColorScheme.dark(
                      secondary: MyColors.primary,
                    ),
                  ),
                ),
                locale: Locale('en', 'US'),
              );
              if (entity != null && context.mounted) {
                Navigator.of(context).pop([entity]);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.circular(0),
              ),
              child: Center(
                child: Icon(
                  Icons.camera_alt,
                  size: 48,
                  color: MyColors.primary1,
                ),
              ),
            ),
          );
        },
      ),
    ]
        : [];

    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      key: UniqueKey(),
      pickerConfig: AssetPickerConfig(
        maxAssets: maxCount,
        requestType: requestType,
        specialPickerType: isSingle ? SpecialPickerType.noPreview : null,
        specialItems: specialItems,
        gridCount: 4,
        pageSize: 40,
        themeColor: MyColors.primary,
        loadingIndicatorBuilder: (BuildContext context, bool isLoadingAssets) {
          if (isLoadingAssets) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  text_widget(
                    'Loading gallery images...',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: MyColors.primary,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );

    if (result == null || result.isEmpty) {
      return null;
    }
    final List<File> files = [];
    for (final entity in result) {
      final File? file = await entity.file;
      if (file != null) {
        files.add(file);
      }
    }
    if (maxCount == 1) {
      final result = await showCupertinoImageCropper(
        context,
        imageProvider: FileImage(files.first),
        themeData: CupertinoThemeData(
          primaryColor: MyColors.primary,
          barBackgroundColor: MyColors.primary,
          primaryContrastingColor: MyColors.primary,
          scaffoldBackgroundColor: MyColors.primary1,
          selectionHandleColor: MyColors.primary,
          textTheme: CupertinoTextThemeData(primaryColor: MyColors.primary),
        ),
        heroTag: 'image',
        allowedAspectRatios: isCircleCrop
            ? []
            : [
          CropAspectRatio(height: 1, width: 3),
          CropAspectRatio(height: 1, width: 2),
          CropAspectRatio(height: 1, width: 1),
        ],
        showLoadingIndicatorOnSubmit: true,
      );
      if (result != null) {
        files.first = await _uiImageToFile(result.uiImage);
      } else {
        return null;
      }
    }
    List<File> image = [];
    for (File file in files) {
      image.add(file);
    }
    return image;
  }

  Future<File?> getImage({
    required BuildContext context,
    int source = 0,
    bool isCircleCrop = false,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source == 0 ? ImageSource.gallery : ImageSource.camera,
    );
    if (image == null) {
      return null;
    }
    File file = File(image.path);
    final result = await showCupertinoImageCropper(
      context,
      imageProvider: FileImage(file),
      themeData: CupertinoThemeData(
        primaryColor: MyColors.white,
        barBackgroundColor: MyColors.white,
        primaryContrastingColor: MyColors.white,
        scaffoldBackgroundColor: MyColors.grey,
        selectionHandleColor: MyColors.white,
        textTheme: CupertinoTextThemeData(primaryColor: MyColors.white),
      ),
      heroTag: 'image',
      allowedAspectRatios: [CropAspectRatio(height: 1, width: 1)],
      showLoadingIndicatorOnSubmit: true,
    );
    if (result != null) {
      file = await _uiImageToFile(result.uiImage);
    } else {
      return null;
    }
    return file;
  }

  Future<File?> getFile({
    required BuildContext context,
    bool isCircleCrop = false,
    bool isImage = false,
    bool allowMultiple = false,
  }) async {
    FilePickerResult? image = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: isImage ? ['jpg', 'png'] : ['pdf', 'doc'],
    );
    if (image == null) {
      return null;
    }
    File file = File(image.files.single.path!);
    if (isImage && !allowMultiple) {
      final result = await showCupertinoImageCropper(
        context,
        imageProvider: FileImage(file),
        themeData: CupertinoThemeData(
          primaryColor: MyColors.white,
          barBackgroundColor: MyColors.white,
          primaryContrastingColor: MyColors.white,
          scaffoldBackgroundColor: MyColors.grey,
          selectionHandleColor: MyColors.white,
          textTheme: CupertinoTextThemeData(primaryColor: MyColors.white),
        ),
        heroTag: 'image',
        allowedAspectRatios: [CropAspectRatio(height: 1, width: 2)],
        showLoadingIndicatorOnSubmit: true,
      );
      if (result != null) {
        file = await _uiImageToFile(result.uiImage);
      } else {
        return null;
      }
    }
    return file;
  }

  Future<File> _uiImageToFile(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    final directory = await path_provider.getTemporaryDirectory();
    final filePath =
        '${directory.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png';

    final file = File(filePath);
    await file.writeAsBytes(pngBytes);

    return file;
  }

  String getFirebaseErrorMessage(Object error) {
    if (error is! FirebaseException) {
      return 'Something went wrong. Please try again';
    }

    switch (error.code) {
      case 'invalid-email':
        return 'Email is not valid';
      case 'email-already-in-use':
        return 'Email already exists';
      case 'weak-password':
        return 'Password is too weak';
      case 'missing-email':
        return 'Email cannot be empty';
      case 'missing-password':
        return 'Password cannot be empty';
      case 'invalid-password':
        return 'Invalid password format';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'user-disabled':
        return 'Account has been disabled';
      case 'requires-recent-login':
        return 'Please log in again';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'operation-not-allowed':
        return 'This sign-in method is disabled';
      case 'permission-denied':
        return 'You do not have permission to perform this action';
      case 'not-found':
        return 'Requested data not found';
      case 'already-exists':
        return 'Data already exists';
      case 'deadline-exceeded':
        return 'Request timed out';
      case 'resource-exhausted':
        return 'Too many requests. Please slow down';
      case 'failed-precondition':
        return 'Operation failed due to system state';
      case 'aborted':
        return 'Operation aborted. Please retry';
      case 'out-of-range':
        return 'Invalid data range';
      case 'unavailable':
        return 'Service temporarily unavailable';
      case 'unauthenticated':
        return 'Please sign in to continue';
      case 'object-not-found':
        return 'File not found';
      case 'bucket-not-found':
        return 'Storage bucket not found';
      case 'project-not-found':
        return 'Project not found';
      case 'quota-exceeded':
        return 'Storage quota exceeded';
      case 'unauthorized':
        return 'You are not allowed to perform this action';
      case 'retry-limit-exceeded':
        return 'Operation failed. Please try again';
      case 'invalid-checksum':
        return 'Upload failed. Please try again';
      case 'canceled':
        return 'Operation cancelled';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      case 'internal-error':
        return 'Internal error. Please try again';
      default:
        return 'Something went wrong. Please try again';
    }
  }
}

extension StringPathCheck on String {
  static final _assetImageRegex = RegExp(
    r'^assets\/.+\.(png|jpg|jpeg|gif|svg|webp)$',
  );

  bool get isLocalPath {
    return _assetImageRegex.hasMatch(toLowerCase());
  }

  bool get isOnlinePath {
    final uri = Uri.tryParse(this);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }
}
