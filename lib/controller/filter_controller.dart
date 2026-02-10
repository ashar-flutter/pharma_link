import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/services/map_service.dart';

class FilterController extends GetxController {
  final MapServices _mapServices = MapServices();
  final TextEditingController locationSearchController =
  TextEditingController();

  String? selectedLocation;
  List<String> selectedJobTypes = [];
  DateTime? selectedStartDate;

  List<String> availableCities = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      isLoading = true;
      update();

      String userCountry = currentUser.country.trim().toLowerCase();

      print('DEBUG - currentUser.country: "${currentUser.country}"');
      print('DEBUG - userCountry after trim/lowercase: "$userCountry"');
      print('DEBUG - userCountry isEmpty: ${userCountry.isEmpty}');

      if (userCountry.isEmpty) {
        print('⚠️ WARNING: User country is empty!');
        availableCities = [];
      } else {
        availableCities = await _mapServices.getCitiesForCountry(userCountry);
      }

      availableCities.sort();

      if (kDebugMode) {
        print('✅ Loaded ${availableCities.length} cities for: $userCountry');
      }

      isLoading = false;
      update();
    } catch (e) {
      if (kDebugMode) print('❌ Error loading cities: $e');
      isLoading = false;
      update();
    }
  }

  List<String> getCitiesToShow() {
    if (availableCities.isEmpty) {
      return ["No cities available"];
    }
    return availableCities;
  }

  void onCitySelected(String city) {
    if (city == "No cities available") return;
    selectedLocation = city;
    locationSearchController.clear();
    update();
  }

  void toggleJobType(String jobType) {
    if (selectedJobTypes.contains(jobType)) {
      selectedJobTypes.remove(jobType);
    } else {
      selectedJobTypes.add(jobType);
    }
    update();
  }

  void setStartDate(DateTime date) {
    selectedStartDate = date;
    update();
  }

  Future<void> applyFilters() async {
    if (selectedLocation == null || selectedLocation!.isEmpty) {
      EasyLoading.showInfo("Please select city");
      return;
    }

    if (selectedJobTypes.isEmpty) {
      EasyLoading.showInfo("Please select job type");
      return;
    }

    if (selectedStartDate == null) {
      EasyLoading.showInfo("Please select date");
      return;
    }

    try {
      EasyLoading.show(status: 'Applying filters...');

      String userCountry = currentUser.country.trim().toLowerCase();

      await _mapServices.filterJobs(
        selectedCountry: userCountry,
        selectedCity: selectedLocation,
        selectedJobTypes: selectedJobTypes,
        startDate: selectedStartDate,
      );

      await Future.delayed(Duration(milliseconds: 300));
      EasyLoading.showSuccess("Done!");
      await Future.delayed(Duration(milliseconds: 500));
      Get.back();
    } catch (e) {
      EasyLoading.showError("Error");
    }
  }

  void clearFilters() {
    selectedLocation = null;
    selectedJobTypes.clear();
    selectedStartDate = null;
    locationSearchController.clear();
    update();
  }

  @override
  void onClose() {
    locationSearchController.dispose();
    super.onClose();
  }
}