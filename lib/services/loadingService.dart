import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:linkpharma/config/colors.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class LoadingService {
  LoadingService._internal();
  static final LoadingService I = LoadingService._internal();

  void show(BuildContext? context, {bool dismissible = true}) {
    FocusManager.instance.primaryFocus?.unfocus();
    EasyLoading.show(indicator: customLoaderEasyloading());
  }

  void dismiss() {
    EasyLoading.dismiss();
  }
}

Widget customLoaderEasyloading() {
  return Stack(
    alignment: Alignment.center,
    children: [
      _DashedCircularLoader(),
      Image.asset('assets/icons/logo.png', height: 7.5.h),
    ],
  );
}

class _DashedCircularLoader extends StatelessWidget {
  const _DashedCircularLoader();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 5),
      duration: const Duration(milliseconds: 3500),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 6.28,
          child: CustomPaint(
            size: const Size(90, 90),
            painter: _DashedCirclePainter(),
          ),
        );
      },
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MyColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const dashWidth = 6;
    const dashSpace = 10;
    final radius = size.width / 2;
    double startAngle = 0;
    while (startAngle < 6.28) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        dashWidth * 0.02,
        false,
        paint,
      );
      startAngle += (dashWidth + dashSpace) * 0.02;
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
