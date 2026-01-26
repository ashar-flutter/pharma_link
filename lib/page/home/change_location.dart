import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class ChangeLocation extends StatefulWidget {
  bool back = false;
  ChangeLocation({super.key, required this.back});

  @override
  State<ChangeLocation> createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  GoogleMapController? _controller;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: MyColors.primary,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: 85.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textFieldWithPrefixSuffuxIconAndHintText(
                "Enter Location",

                obsecure: false,
              ),
              SizedBox(height: 3.h),
              gradientButton(
                "Save".tr,
                font: 16,
                txtColor: MyColors.white,
                ontap: () {},
                isGrediant: false,
                width: 90,

                height: 6,
                isColor: true,
                clr: MyColors.primary,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              // height: 13.h,
              decoration: BoxDecoration(color: MyColors.primary),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Row(
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
                        "Change Location",
                        color: Colors.white,
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      Spacer(),
                      Image.asset(
                        "assets/images/back.png",
                        height: 3.5.h,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(33.489044, 73.089211),
                        zoom: 40.0,
                      ),
                      zoomControlsEnabled: false,
                      onMapCreated: (GoogleMapController controller) async {
                        _controller = controller;
                        await _controller!.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(33.499044, 73.099411),
                              zoom: 14.4746,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Align(
                    child: Image.asset("assets/icons/loc.png", height: 6.h),
                  ),
                  Positioned.fill(
                    top: 3.h,
                    right: 4.w,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset("assets/icons/cloc.png", height: 5.h),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
