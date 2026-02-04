import 'package:get/get.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/models/job_model.dart';

import '../services/map_service.dart';
import 'job_controller.dart';

class MapController extends GetxController {
  final MapServices _mapServices = MapServices();

  List<JobModel> mapJobs = [];
  bool isLoadingMapJobs = false;

  String? selectedCity;
  List<String> selectedContractTypes = [];
  DateTime? periodFrom;
  DateTime? periodTo;

  @override
  void onInit() {
    super.onInit();
    loadMapJobs();
  }

  Future<void> loadMapJobs() async {
    if (currentUser.userType != 1) return;

    isLoadingMapJobs = true;
    update();

    try {
      mapJobs = await _mapServices.getMapJobs(
        currentUser.country,
        city: selectedCity,
      );
    } catch (e) {
      mapJobs = [];
    }

    isLoadingMapJobs = false;
    update();
  }

  Future<void> applyFilters() async {
    if (currentUser.userType != 1) return;

    isLoadingMapJobs = true;
    update();

    try {
      mapJobs = await _mapServices.getFilteredJobs(
        country: currentUser.country,
        city: selectedCity,
        contractTypes: selectedContractTypes.isNotEmpty
            ? selectedContractTypes
            : null,
        startDate: periodFrom,
      );
    } catch (e) {
      mapJobs = [];
    }

    isLoadingMapJobs = false;
    update();
  }

  void clearFilters() {
    selectedCity = null;
    selectedContractTypes.clear();
    periodFrom = null;
    periodTo = null;
    loadMapJobs();
    update();
  }

  void selectCity(String city) {
    selectedCity = city;
    update();
  }

  void toggleContractType(String type) {
    if (selectedContractTypes.contains(type)) {
      selectedContractTypes.remove(type);
    } else {
      selectedContractTypes.add(type);
    }
    update();
  }

  void setPeriodFrom(DateTime date) {
    periodFrom = date;
    update();
  }

  void setPeriodTo(DateTime date) {
    periodTo = date;
    update();
  }

  bool hasUserApplied(String jobId) {
    final jobController = Get.find<JobController>();
    return jobController.hasUserApplied(jobId);
  }

  bool isJobSaved(String jobId) {
    final jobController = Get.find<JobController>();
    return jobController.isJobCurrentlySaved(jobId);
  }

  Future<void> toggleSaveJob(JobModel job) async {
    final jobController = Get.find<JobController>();
    await jobController.toggleJobSaveStatus(job);
    update();
  }

  Future<void> applyForJob(JobModel job) async {
    final jobController = Get.find<JobController>();
    await jobController.applyForJob(job);
  }
}
