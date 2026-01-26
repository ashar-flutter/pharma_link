import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

Widget imageWidget({
  required String image,
  double borderRadius = 0,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  bool isAsset = false,
  double borderWidth = 0,
  Color borderColor = Colors.transparent,
}) {
  final Widget imageChild = image.isURL
      ? CachedNetworkImage(
          imageUrl: image,
          fit: fit,
          width: width != null ? width - (borderWidth * 2) : 100.w,
          height: height != null ? height - (borderWidth * 2) : 100.w,
          placeholder: (BuildContext context, url) =>
              const _ShimmerPlaceholder(),
          errorWidget: (BuildContext context, url, error) =>
              _buildErrorWidget(width, height, url: image),
          fadeInDuration: const Duration(milliseconds: 300),
        )
      : Image.file(
          File(image),
          fit: fit,
          width: width != null ? width - (borderWidth * 2) : 100.w,
          height: height != null ? height - (borderWidth * 2) : null,
          errorBuilder: (BuildContext context, error, stackTrace) =>
              _buildErrorWidget(width, height),
        );

  // If borderWidth is 0, return just the clipped image
  if (borderWidth <= 0) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageChild,
    );
  }

  // Return image with border
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: borderWidth),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Padding(padding: EdgeInsets.all(borderWidth), child: imageChild),
    ),
  );
}

class _ShimmerPlaceholder extends StatelessWidget {
  const _ShimmerPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      interval: Duration(seconds: 0),
      duration: Duration(seconds: 2),
      colorOpacity: 1,
      direction: ShimmerDirection.fromLTRB(),
      child: Container(color: Colors.grey.shade300),
    );
  }
}

Widget _buildErrorWidget(double? width, double? height, {String url = ""}) {
  return Container(
    color: Colors.grey[300],
    width: width,
    height: height,
    child: Center(child: text_widget("File is attached!!", color: Colors.grey)),
  );
}
