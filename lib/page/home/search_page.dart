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
  bool _markersInitialized = false;

  CameraPosition get _initialCameraPosition {
    if (_mapController.currentLat != 0.0 && _mapController.currentLng != 0.0) {
      return CameraPosition(
        target: LatLng(_mapController.currentLat, _mapController.currentLng),
        zoom: 12.0,
      );
    }

    if (_mapController.currentUser.country.toLowerCase().contains("pakistan")) {
      return CameraPosition(
        target: LatLng(33.6844, 73.0479),
        zoom: 12.0,
      );
    } else if (_mapController.currentUser.country.toLowerCase().contains("india")) {
      return CameraPosition(
        target: LatLng(28.6139, 77.2090),
        zoom: 12.0,
      );
    } else {
      return CameraPosition(
        target: LatLng(20.5937, 78.9629),
        zoom: 3.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // ✅ Add small delay to ensure map is ready
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        addMarkers();
        _moveMapToCurrentPosition();
      }
    });
  }

  /// ✅ Smooth map movement to current position
  Future<void> _moveMapToCurrentPosition() async {
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

  /// ✅ FIXED: Add markers with proper error handling and real-time updates
  Future<void> addMarkers() async {
    if (_mapController.mapJobs.isEmpty) {
      print("❌ No jobs available for markers");
      return;
    }

    print("✅ Starting to add ${_mapController.mapJobs.length} markers");

    Set<Marker> markers = {};
    int validMarkers = 0;
    int invalidMarkers = 0;

    for (var job in _mapController.mapJobs) {
      if (job.vendorLat != 0.0 && job.vendorLng != 0.0) {
        try {
          print("🔄 Processing job: ${job.vendorName} at (${job.vendorLat}, ${job.vendorLng})");

          BitmapDescriptor markerIcon = await getMarkerIcon(
            job.vendorImage.isNotEmpty ? job.vendorImage : "",
            Size(200.0, 200.0), // ✅ BIGGER SIZE
          );

          Marker marker = Marker(
            markerId: MarkerId(job.id),
            position: LatLng(job.vendorLat, job.vendorLng),
            icon: markerIcon,
            infoWindow: InfoWindow(
              title: job.vendorName,
              snippet: job.title,
            ),
            onTap: () {
              print("📍 Tapped marker: ${job.id}");
              _mapController.selectMarker(job.id);

              // ✅ Smooth animation to marker
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
          validMarkers++;
          print("✅ Marker added: ${job.vendorName}");
        } catch (e) {
          invalidMarkers++;
          print("❌ Error adding marker for ${job.vendorName}: $e");
        }
      } else {
        invalidMarkers++;
        print("⚠️ Job has no valid coordinates: ${job.vendorName}");
      }
    }

    print("📊 Markers Summary: Valid=$validMarkers, Invalid=$invalidMarkers");

    // ✅ Update controller with markers
    _mapController.markers = markers;
    _mapController.update();

    // ✅ Force UI rebuild
    if (mounted) {
      setState(() {
        _markersInitialized = true;
      });
    }
  }

  /// ✅ IMPROVED: Better marker icon generation with larger circles
  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      final Radius radius = Radius.circular(size.width / 2); // ✅ Perfect circle
      final double shadowWidth = 20.0; // ✅ BIGGER shadow
      final double borderWidth = 5.0; // ✅ BIGGER border
      final double imageOffset = shadowWidth + borderWidth;

      // ✅ Shadow layer (outer circle)
      final Paint shadowPaint = Paint()
        ..color = MyColors.primary.withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, 8.0);

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

      // ✅ Border layer
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

      // ✅ Inner circle for image
      Rect oval = Rect.fromLTWH(
        imageOffset,
        imageOffset,
        size.width - (imageOffset * 2),
        size.height - (imageOffset * 2),
      );

      // ✅ Clip to circle
      canvas.clipPath(Path()..addOval(oval));

      // ✅ Load and paint image
      if (imagePath.isNotEmpty) {
        try {
          ui.Image image = await getImageFromPath(imagePath);
          paintImage(
            canvas: canvas,
            image: image,
            rect: oval,
            fit: BoxFit.cover,
          );
          print("✅ Image loaded for marker");
        } catch (e) {
          print("⚠️ Image load failed: $e, using fallback color");
          final Paint fallbackPaint = Paint()..color = Colors.grey[400]!;
          canvas.drawOval(oval, fallbackPaint);
        }
      } else {
        // ✅ Fallback: solid color circle
        final Paint fallbackPaint = Paint()..color = Colors.grey[300]!;
        canvas.drawOval(oval, fallbackPaint);
      }

      // ✅ Convert to bitmap
      final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
        size.width.toInt(),
        size.height.toInt(),
      );

      final ByteData? byteData = await markerAsImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception("Failed to convert image to bytes");
      }

      final Uint8List uint8List = byteData.buffer.asUint8List();
      print("✅ Marker icon generated, size: ${uint8List.length} bytes");

      return BitmapDescriptor.fromBytes(uint8List);
    } catch (e) {
      print("❌ Marker icon generation failed: $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

  Future<ui.Image> getImageFromPath(String imagePath) async {
    try {
      print("🔄 Loading image from: $imagePath");

      Uint8List bytes = (await NetworkAssetBundle(
        Uri.parse(imagePath),
      ).load(imagePath)).buffer.asUint8List();

      final Completer<ui.Image> completer = Completer();

      ui.decodeImageFromList(bytes, (ui.Image img) {
        completer.complete(img);
      });

      final image = await completer.future;
      print("✅ Image decoded successfully");
      return image;
    } catch (e) {
      print("❌ Image loading failed: $e");
      throw e;
    }
  }

  void _handleSearch(String query) {
    print("🔍 Search query: '$query'");
    _mapController.handleSearch(query);

    // ✅ Re-add markers after search
    Future.delayed(Duration(milliseconds: 1200), () {
      if (mounted) {
        print("🔄 Updating markers after search...");
        addMarkers();
        _moveMapToCurrentPosition();
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
              child: Column(
                children: [
                  Row(
                    children: [
                      onPress(
                        ontap: () => Get.back(),
                        child: Image.asset(
                          "assets/images/back.png",
                          height: 3.5.h,
                        ),
                      ),
                      Spacer(),
                      text_widget(
                        "Search",
                        color: Colors.white,
                        fontSize: 21.sp,
                      ),
                      Spacer(),
                      Image.asset(
                        "assets/images/back.png",
                        height: 3.5.h,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
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
                          markers: controller.markers, // ✅ Real-time updates
                          onMapCreated: (GoogleMapController mapController) {
                            print("🗺️ Map created");
                            _googleMapController = mapController;
                            Future.delayed(Duration(milliseconds: 300), () {
                              if (mounted) {
                                addMarkers();
                                _moveMapToCurrentPosition();
                              }
                            });
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
                                  padding: EdgeInsets.all(10),
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
                        Spacer(),
                        // ✅ Bottom job list - shows when marker selected
                        GetBuilder<MapController>(
                          builder: (controller) {
                            if (controller.filteredJobs.isEmpty) {
                              return SizedBox();
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
                                      padding: EdgeInsets.only(left: 18, right: 18),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: controller.selectedMarkerJobId == job.id
                                              ? MyColors.primary
                                              : const Color(0xffF6F6F6),
                                          borderRadius: BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.vertical(
                                                top: Radius.circular(18),
                                              ),
                                              child: job.vendorImage.isNotEmpty
                                                  ? Image.network(
                                                job.vendorImage,
                                                width: 40.w,
                                                height: 14.h,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    width: 40.w,
                                                    height: 14.h,
                                                    color: MyColors.primary.withOpacity(0.1),
                                                    child: Icon(Icons.image_not_supported),
                                                  );
                                                },
                                              )
                                                  : Container(
                                                width: 40.w,
                                                height: 14.h,
                                                color: MyColors.primary.withOpacity(0.1),
                                                child: Icon(Icons.store),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 6,
                                              ),
                                              child: Text(
                                                job.vendorName,
                                                style: GoogleFonts.plusJakartaSans(
                                                  color: controller.selectedMarkerJobId == job.id
                                                      ? Colors.white
                                                      : Color(0xff1E1E1E),
                                                  fontSize: 14.5.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                              child: Text(
                                                "${job.title} - ${job.contractType}",
                                                style: GoogleFonts.plusJakartaSans(
                                                  color: controller.selectedMarkerJobId == job.id
                                                      ? Colors.white70
                                                      : Color.fromARGB(110, 30, 30, 30),
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