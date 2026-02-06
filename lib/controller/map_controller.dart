import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linkpharma/models/job_model.dart';

import '../config/global.dart' as global;
import '../models/user_model.dart';
import '../services/map_service.dart';

class MapController extends GetxController {
  final MapServices _mapServices = MapServices();

  // ===================== STATE =====================
  List<JobModel> mapJobs = [];
  List<JobModel> filteredJobs = [];
  Set<Marker> markers = {};
  String currentCity = "";
  String currentCountry = "";
  double currentLat = 0.0;
  double currentLng = 0.0;
  String? selectedMarkerJobId;
  Timer? _searchTimer;
  bool isSearching = false;
  List<String> citySuggestions = [];
  String currentSearchPlace = ""; // Track current search place

  UserModel get currentUser => global.currentUser;

  @override
  void onInit() {
    super.onInit();
    _initializeMap();
  }

  void _initializeMap() {
    currentCity = currentUser.city;
    currentCountry = currentUser.country;

    _requestLocationPermission();
    _loadJobsForCurrentCity();
    _loadCitySuggestions();
  }

  Future<void> _requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        _getUserCurrentLocation();
      }
    } catch (e) {
      // Location error - app continues
    }
  }

  Future<void> _getUserCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      currentLat = position.latitude;
      currentLng = position.longitude;
      update();
    } catch (e) {
      // Location not available
    }
  }

  Future<void> _loadCitySuggestions() async {
    try {
      citySuggestions = await _mapServices.getAllCitiesForCountry(
        currentCountry,
      );
      update();
    } catch (e) {
      // Error loading suggestions
    }
  }

  Future<void> _loadJobsForCurrentCity() async {
    if (currentUser.userType != 1) return;

    try {
      mapJobs = await _mapServices.getJobsByCity(
        country: currentCountry,
        city: currentCity,
      );

      filteredJobs = [];
      markers.clear();
      selectedMarkerJobId = null;

      if (mapJobs.isNotEmpty) {
        for (var job in mapJobs) {
          if (job.vendorLat != 0.0 && job.vendorLng != 0.0) {
            currentLat = job.vendorLat;
            currentLng = job.vendorLng;
            break;
          }
        }
      }
    } catch (e) {
      mapJobs = [];
    }

    update();
  }

  void handleSearch(String query) {
    if (_searchTimer != null) {
      _searchTimer!.cancel();
    }

    isSearching = true;
    update();

    _searchTimer = Timer(const Duration(milliseconds: 300), () {
      if (query.trim().isEmpty) {
        _loadJobsForCurrentCity();
      } else {
        _searchPlace(query.trim());
      }

      isSearching = false;
      update();
    });
  }

  Future<void> _searchPlace(String placeName) async {
    try {
      if (kDebugMode) {
        print('\n🔵 ========== PLACE SEARCH START ==========');
      }
      if (kDebugMode) {
        print('User searching: "$placeName"');
      }

      var result = await _mapServices.searchPlaceAndJobs(placeName: placeName);

      mapJobs = result['jobs'] ?? [];
      currentLat = result['lat'] ?? 0.0;
      currentLng = result['lng'] ?? 0.0;
      bool hasJobs = result['hasJobs'] ?? false;

      if (kDebugMode) {
        print('Search Results:');
      }
      if (kDebugMode) {
        print('Place: "$placeName"');
      }
      if (kDebugMode) {
        print('Coordinates: $currentLat, $currentLng');
      }
      if (kDebugMode) {
        print('Jobs found: ${mapJobs.length}');
      }
      if (kDebugMode) {
        print('Has jobs: $hasJobs');
      }

      filteredJobs = [];
      markers.clear();
      selectedMarkerJobId = null;

      if (hasJobs) {
        if (kDebugMode) {
          print('Jobs found! Showing markers...');
        }
      } else {
        if (kDebugMode) {
          print(' No jobs, but showing place on map...');
        }
      }

      if (kDebugMode) {
        print(' ========== PLACE SEARCH END ==========\n');
      }
    } catch (e) {
      if (kDebugMode) {
        print(' Error in search: $e');
      }
      mapJobs = [];
    }

    update();
  }

  void selectMarker(String jobId) {
    selectedMarkerJobId = jobId;
    filteredJobs = mapJobs.where((job) => job.id == jobId).toList();
    update();
  }

  CameraPosition get initialCameraPosition {
    if (currentLat != 0.0 && currentLng != 0.0) {
      return CameraPosition(target: LatLng(currentLat, currentLng), zoom: 12.0);
    }

    if (currentUser.latitude != 0.0 && currentUser.longitude != 0.0) {
      return CameraPosition(
        target: LatLng(currentUser.latitude, currentUser.longitude),
        zoom: 12.0,
      );
    }

    return CameraPosition(target: const LatLng(20.0, 0.0), zoom: 2.0);
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    super.onClose();
  }
}
