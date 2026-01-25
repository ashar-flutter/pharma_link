import 'package:url_launcher/url_launcher.dart';

class SupportFunctions {
  static final SupportFunctions I = SupportFunctions._();
  SupportFunctions._();

  Future<void> launchLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
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
