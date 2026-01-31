import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/models/job_model.dart';
import 'package:linkpharma/page/home/filter_page.dart';
import 'package:linkpharma/page/home/pharmaceydetail.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'dart:ui' as ui;
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  Set<Marker> markers = {};

  GoogleMapController? _controller;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final double _sliderValue = 0;
  @override
  void initState() {
    super.initState();
    addMarkers();
    setState(() {});
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  LatLng startLocation = LatLng(27.6602292, 85.308027);
  LatLng endLocation = LatLng(27.6599592, 85.3102498);

  Future<void> addMarkers() async {
    markers.add(
      Marker(
        onTap: () {},
        markerId: MarkerId(startLocation.toString()),
        position: LatLng(33.499044, 73.093411),
        icon: await getMarkerIcon(
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
          Size(170.0, 170.0),
        ),
      ),
    );
    markers.add(
      Marker(
        onTap: () {},
        markerId: MarkerId("33.897890"),
        position: LatLng(33.489094, 73.099411),
        icon: await getMarkerIcon(
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",

          Size(170.0, 170.0),
        ),
      ),
    );

    if (_controller == null) return;
    await _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(33.489044, 73.089211), zoom: 14.4746),
      ),
    );
    setState(() {});
  }

  PageController controller = PageController();
  int selectPage = 0;

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
                        ontap: () {
                          Get.back();
                        },
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
                    child: GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: true,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(33.489044, 73.089211),
                        zoom: 15.0,
                      ),
                      markers: markers,
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
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
                                  ),
                                  alignment: Alignment.center,
                                  child: TextField(
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 14.sp,
                                    ),
                                    cursorColor: Color(0xffFFFFFF),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isCollapsed: true,
                                      hintText: "Search text here...",
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
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              onPress(
                                ontap: () {
                                  Get.to(FilterPage());
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  height: 5.h,
                                  width: 12.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color(0xffFFFFFF),
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(3, (index) {
                              final bool isLast = index == 2;
                              return onPress(
                                ontap: () {
                                  Get.to(PharmaceyDetail(job: JobModel(),));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 18,
                                    right: isLast
                                        ? 18
                                        : 0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: index == 0
                                          ? MyColors.primary
                                          : const Color(0xffF6F6F6),
                                      borderRadius: BorderRadius.circular(18),
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
                                          child: Image.asset(
                                            "assets/images/as52.png",
                                            width: 40.w,
                                            height: 14.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 6,
                                          ),
                                          child: Text(
                                            "Pharmacie du Centre",
                                            style: GoogleFonts.plusJakartaSans(
                                              color: index == 0
                                                  ? Colors.white
                                                  : Color(0xff1E1E1E),
                                              fontSize: 14.5.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            "Pharmacist-Full Time,\nInternship, Assistant",
                                            style: GoogleFonts.plusJakartaSans(
                                              color: index == 0
                                                  ? Colors.white
                                                  : Color.fromARGB(
                                                      110,
                                                      30,
                                                      30,
                                                      30,
                                                    ),
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
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

Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final Radius radius = Radius.circular(size.width / 1.8);

  final Paint tagPaint = Paint()..color = Colors.transparent;
  final double tagWidth = 40.0;

  final Paint shadowPaint = Paint()..color = MyColors.primary;
  final double shadowWidth = 15.0;

  final Paint borderPaint = Paint()..color = MyColors.primary;
  final double borderWidth = 3.0;

  final double imageOffset = shadowWidth + borderWidth;

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

  canvas.drawRRect(
    RRect.fromRectAndCorners(
      Rect.fromLTWH(
        shadowWidth,
        shadowWidth,
        size.width - (shadowWidth * 2),
        size.height - (shadowWidth * 2),
      ),
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    ),
    borderPaint,
  );

  canvas.drawRRect(
    RRect.fromRectAndCorners(
      Rect.fromLTWH(size.width - tagWidth, 0.0, tagWidth, tagWidth),
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    ),
    tagPaint,
  );

  Rect oval = Rect.fromLTWH(
    imageOffset,
    imageOffset,
    size.width - (imageOffset * 2),
    size.height - (imageOffset * 2),
  );

  canvas.clipPath(Path()..addOval(oval));

  ui.Image image = await getImageFromPath(imagePath);
  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fill);

  final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
    size.width.toInt(),
    size.height.toInt(),
  );

  final ByteData? byteData = await markerAsImage.toByteData(
    format: ui.ImageByteFormat.png,
  );
  final Uint8List uint8List = byteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List);
}

Future<ui.Image> getImageFromPath(String imagePath) async {
  Uint8List bytes = (await NetworkAssetBundle(
    Uri.parse(imagePath),
  ).load(imagePath)).buffer.asUint8List();

  final Completer<ui.Image> completer = Completer();

  ui.decodeImageFromList(bytes, (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}

class TimelineSlider extends StatefulWidget {
  const TimelineSlider({super.key});

  @override
  _TimelineSliderState createState() => _TimelineSliderState();
}

class _TimelineSliderState extends State<TimelineSlider> {
  double _currentValue = 0;

  final List<String> labels = ["Today", "1 W", "2 W", "1 M"];
  final double maxSliderValue = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.teal,
                inactiveTrackColor: Colors.teal[200],
                thumbColor: Colors.orange,
                overlayShape: SliderComponentShape.noOverlay,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                trackHeight: 4.0,
              ),
              child: Slider(
                min: 0,
                max: maxSliderValue,
                divisions: maxSliderValue.toInt(),
                value: _currentValue,
                onChanged: (value) {
                  setState(() {
                    _currentValue = value;
                  });
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels.asMap().entries.map((entry) {
                int idx = entry.key;
                return Column(
                  children: [
                    Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: idx <= _currentValue
                            ? Colors.orange
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
        SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels.asMap().entries.map((entry) {
            int idx = entry.key;
            String label = entry.value;
            return Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: idx == _currentValue ? Colors.orange : Colors.grey[800],
                fontWeight: idx == _currentValue
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
