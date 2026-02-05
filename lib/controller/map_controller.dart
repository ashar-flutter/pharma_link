import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linkpharma/models/job_model.dart';

import '../config/global.dart' as Global;
import '../models/user_model.dart';
import '../services/map_service.dart';

class MapController extends GetxController {
  final MapServices _mapServices = MapServices();

  // ===================== VARIABLES =====================
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

  // Current user access ke liye
  UserModel get currentUser => Global.currentUser;

  @override
  void onInit() {
    super.onInit();
    print("🚀 MapController initializing...");

    currentCity = currentUser.city;
    currentCountry = currentUser.country;

    print("📍 User - City: $currentCity, Country: $currentCountry");

    // ✅ Request location permission on init
    _requestLocationPermission();

    // ✅ Load initial jobs
    _loadJobsForCurrentCity();

    // ✅ Load city suggestions
    _loadCitySuggestions();
  }

  // ===================== LOCATION PERMISSION =====================
  Future<void> _requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        print("⚠️ Location permission denied, requesting...");
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        print("✅ Location permission granted");
        _getUserCurrentLocation();
      } else {
        print("❌ Location permission not granted");
      }
    } catch (e) {
      print("❌ Location permission error: $e");
    }
  }

  Future<void> _getUserCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat = position.latitude;
      currentLng = position.longitude;

      print("✅ User location: $currentLat, $currentLng");
      update();
    } catch (e) {
      print("❌ Error getting user location: $e");
    }
  }

  // ===================== LOAD CITY SUGGESTIONS =====================
  Future<void> _loadCitySuggestions() async {
    try {
      citySuggestions = await _mapServices.getAllCitiesForCountry(currentCountry);
      print("✅ Loaded ${citySuggestions.length} city suggestions");
      update();
    } catch (e) {
      print("❌ Error loading suggestions: $e");
    }
  }

  // ===================== LOAD JOBS FOR CURRENT CITY =====================
  Future<void> _loadJobsForCurrentCity() async {
    if (currentUser.userType != 1) return;

    try {
      print("🔄 Loading jobs for $currentCity in $currentCountry...");

      mapJobs = await _mapServices.getJobsByCity(
        country: currentCountry,
        city: currentCity,
      );

      // ✅ Clear previous state
      filteredJobs = [];
      markers.clear();
      selectedMarkerJobId = null;

      // ✅ Set map center to first job location
      if (mapJobs.isNotEmpty) {
        int validCoords = 0;
        for (var job in mapJobs) {
          if (job.vendorLat != 0.0 && job.vendorLng != 0.0) {
            currentLat = job.vendorLat;
            currentLng = job.vendorLng;
            validCoords++;
            break;
          }
        }
        print("✅ Loaded ${mapJobs.length} jobs - $validCoords have valid coordinates");
      } else {
        print("⚠️ No jobs found for $currentCity");
      }
    } catch (e) {
      print("❌ Error loading jobs: $e");
      mapJobs = [];
    }

    update();
  }

  // ===================== SEARCH FUNCTIONALITY =====================
  void handleSearch(String query) {
    print("🔍 handleSearch called with: '$query'");

    // ✅ Cancel previous timer
    if (_searchTimer != null) {
      _searchTimer!.cancel();
    }

    // ✅ Show loading state
    isSearching = true;
    update();

    // ✅ Debounce search by 800ms
    _searchTimer = Timer(Duration(milliseconds: 800), () {
      if (query.trim().isEmpty) {
        print("🔄 Search cleared - resetting to current city");
        _loadJobsForCurrentCity();
      } else {
        print("🔍 Searching for: ${query.trim()}");
        _searchCityJobs(query.trim());
      }

      isSearching = false;
      update();
    });
  }

  Future<void> _searchCityJobs(String cityName) async {
    try {
      print("🔍 Searching for city: $cityName");

      // ✅ Get jobs for searched city
      mapJobs = await _mapServices.getJobsByCityName(cityName: cityName);

      // ✅ Reset UI state
      filteredJobs = [];
      markers.clear();
      selectedMarkerJobId = null;

      if (mapJobs.isNotEmpty) {
        // ✅ Find first valid location and center map there
        int validCoords = 0;
        for (var job in mapJobs) {
          if (job.vendorLat != 0.0 && job.vendorLng != 0.0) {
            currentLat = job.vendorLat;
            currentLng = job.vendorLng;
            currentCity = job.vendorCity;
            currentCountry = job.vendorCountry;
            validCoords++;
            break;
          }
        }
        print("✅ Found ${mapJobs.length} jobs in $cityName - $validCoords with valid coordinates");
        print("📍 Map center: $currentLat, $currentLng");
      } else {
        print("⚠️ No jobs found for $cityName");
        currentLat = 0.0;
        currentLng = 0.0;
      }
    } catch (e) {
      print("❌ Search error: $e");
      mapJobs = [];
      currentLat = 0.0;
      currentLng = 0.0;
    }

    update();
  }

  // ===================== MARKER SELECTION =====================
  void selectMarker(String jobId) {
    print("📍 Marker selected: $jobId");
    selectedMarkerJobId = jobId;
    filteredJobs = mapJobs.where((job) => job.id == jobId).toList();

    print("✅ Filtered jobs count: ${filteredJobs.length}");
    if (filteredJobs.isNotEmpty) {
      print("✅ Job: ${filteredJobs.first.vendorName}");
    }

    update();
  }

  // ===================== CAMERA POSITION =====================
  CameraPosition get initialCameraPosition {
    if (currentLat != 0.0 && currentLng != 0.0) {
      return CameraPosition(
        target: LatLng(currentLat, currentLng),
        zoom: 12.0,
      );
    }

    return CameraPosition(
      target: LatLng(0.0, 0.0),
      zoom: 1.0,
    );
  }

  @override
  void onClose() {
    print("🛑 MapController closing");
    _searchTimer?.cancel();
    super.onClose();
  }
}