import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/filter_page.dart';
import 'package:linkpharma/page/home/pharmaceydetail.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/map_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final MapController _mapController = Get.put(MapController());
  GoogleMapController? _googleMapController;
  final TextEditingController _searchController = TextEditingController();

  CameraPosition get _initialCameraPosition {
    return _mapController.initialCameraPosition;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _addMarkers();
        _moveMapToPosition();
      }
    });
  }

  ///  Move map to current position smoothly
  Future<void> _moveMapToPosition() async {
    if (_googleMapController == null) return;

    if (_mapController.currentLat != 0.0 && _mapController.currentLng != 0.0) {
      await _googleMapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_mapController.currentLat, _mapController.currentLng),
          12.0,
        ),
      );
    }
  }

  ///  Add markers from jobs
  Future<void> _addMarkers() async {
    if (_mapController.mapJobs.isEmpty) return;

    Set<Marker> markers = {};

    for (var job in _mapController.mapJobs) {
      if (job.vendorLat != 0.0 && job.vendorLng != 0.0) {
        try {
          BitmapDescriptor markerIcon = await _getMarkerIcon(
            job.vendorImage.isNotEmpty ? job.vendorImage : "",
            const Size(170.0, 170.0),
          );

          Marker marker = Marker(
            markerId: MarkerId(job.id),
            position: LatLng(job.vendorLat, job.vendorLng),
            icon: markerIcon,
            infoWindow: InfoWindow(title: job.vendorName, snippet: job.title),
            onTap: () {
              _mapController.selectMarker(job.id);

              if (_googleMapController != null) {
                _googleMapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(job.vendorLat, job.vendorLng),
                    15.0,
                  ),
                );
              }
            },
          );

          markers.add(marker);
        } catch (e) {
          //
        }
      }
    }

    _mapController.markers = markers;
    _mapController.update();
  }

  Future<BitmapDescriptor> _getMarkerIcon(String imagePath, Size size) async {
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      final Radius radius = Radius.circular(size.width / 2);
      final double shadowWidth = 12.0;
      final double borderWidth = 3.0;
      final double imageOffset = shadowWidth + borderWidth;

      // Shadow
      final Paint shadowPaint = Paint()
        ..color = MyColors.primary.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6.0);

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint,
      );

      final Paint borderPaint = Paint()
        ..color = MyColors.primary
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint,
      );

      final Rect oval = Rect.fromLTWH(
        imageOffset,
        imageOffset,
        size.width - (imageOffset * 2),
        size.height - (imageOffset * 2),
      );

      canvas.clipPath(Path()..addOval(oval));

      if (imagePath.isNotEmpty) {
        try {
          final ui.Image image = await _getImageFromPath(imagePath);
          paintImage(
            canvas: canvas,
            image: image,
            rect: oval,
            fit: BoxFit.cover,
          );
        } catch (e) {
          final Paint fallbackPaint = Paint()..color = Colors.grey[400]!;
          canvas.drawOval(oval, fallbackPaint);
        }
      } else {
        final Paint fallbackPaint = Paint()..color = Colors.grey[300]!;
        canvas.drawOval(oval, fallbackPaint);
      }

      final ui.Image markerAsImage = await pictureRecorder
          .endRecording()
          .toImage(size.width.toInt(), size.height.toInt());

      final ByteData? byteData = await markerAsImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) throw Exception("Image conversion failed");

      final Uint8List uint8List = byteData.buffer.asUint8List();
      return BitmapDescriptor.bytes(uint8List);
    } catch (e) {
      return BitmapDescriptor.defaultMarker;
    }
  }

  Future<ui.Image> _getImageFromPath(String imagePath) async {
    final Uint8List bytes = (await NetworkAssetBundle(
      Uri.parse(imagePath),
    ).load(imagePath)).buffer.asUint8List();

    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });

    return completer.future;
  }

  void _handleSearch(String query) {
    _mapController.handleSearch(query);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _addMarkers();
        _moveMapToPosition();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.primary,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  onPress(
                    ontap: () => Get.back(),
                    child: Image.asset("assets/images/back.png", height: 3.5.h),
                  ),
                  const Spacer(),
                  text_widget("Search", color: Colors.white, fontSize: 21.sp),
                  const Spacer(),
                  Image.asset(
                    "assets/images/back.png",
                    height: 3.5.h,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: GetBuilder<MapController>(
                      builder: (controller) {
                        return GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                          initialCameraPosition: _initialCameraPosition,
                          markers: controller.markers,
                          onMapCreated: (GoogleMapController mapController) {
                            _googleMapController = mapController;
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () {
                                if (mounted) {
                                  _addMarkers();
                                  _moveMapToPosition();
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 5.h,
                                  width: 70.w,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: TextField(
                                    controller: _searchController,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                    ),
                                    cursorColor: MyColors.primary,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isCollapsed: true,
                                      hintText: "Search city...",
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        color: Colors.black54,
                                      ),
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.only(right: 2.w),
                                        child: Image.asset(
                                          "assets/images/as74.png",
                                          height: 2.h,
                                        ),
                                      ),
                                      suffixIconConstraints: BoxConstraints(
                                        minHeight: 2.h,
                                        minWidth: 2.h,
                                      ),
                                    ),
                                    onChanged: _handleSearch,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              onPress(
                                ontap: () => Get.to(FilterPage()),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  height: 5.h,
                                  width: 12.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    "assets/images/as18.png",
                                    height: 1.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        GetBuilder<MapController>(
                          builder: (controller) {
                            if (controller.filteredJobs.isEmpty) {
                              return const SizedBox();
                            }

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: controller.filteredJobs.map((job) {
                                  return onPress(
                                    ontap: () {
                                      Get.to(() => PharmaceyDetail(job: job));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 18,
                                        right: 18,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              controller.selectedMarkerJobId ==
                                                  job.id
                                              ? MyColors.primary
                                              : const Color(0xffF6F6F6),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(18),
                                                  ),
                                              child: job.vendorImage.isNotEmpty
                                                  ? Image.network(
                                                      job.vendorImage,
                                                      width: 40.w,
                                                      height: 14.h,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Container(
                                                              width: 40.w,
                                                              height: 14.h,
                                                              color: MyColors
                                                                  .primary
                                                                  .withValues(
                                                                    alpha: 0.1,
                                                                  ),
                                                              child: const Icon(
                                                                Icons
                                                                    .image_not_supported,
                                                              ),
                                                            );
                                                          },
                                                    )
                                                  : Container(
                                                      width: 40.w,
                                                      height: 14.h,
                                                      color: MyColors.primary
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      child: const Icon(
                                                        Icons.store,
                                                      ),
                                                    ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 6,
                                                  ),
                                              child: Text(
                                                job.vendorName,
                                                style: GoogleFonts.plusJakartaSans(
                                                  color:
                                                      controller
                                                              .selectedMarkerJobId ==
                                                          job.id
                                                      ? Colors.white
                                                      : const Color(0xff1E1E1E),
                                                  fontSize: 14.5.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              child: Text(
                                                "${job.title} - ${job.contractType}",
                                                style: GoogleFonts.plusJakartaSans(
                                                  color:
                                                      controller
                                                              .selectedMarkerJobId ==
                                                          job.id
                                                      ? Colors.white70
                                                      : const Color.fromARGB(
                                                          110,
                                                          30,
                                                          30,
                                                          30,
                                                        ),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 1.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 3.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
