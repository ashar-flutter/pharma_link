import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/models/job_model.dart';
import 'package:linkpharma/services/firestore_services.dart';

import '../models/user_model.dart';
import '../page/home/jobs_aplied.dart';

class JobController extends GetxController {
  // ===================== TEXT CONTROLLERS =====================
  TextEditingController titleController = TextEditingController();
  TextEditingController coefficientController = TextEditingController();
  TextEditingController roleDescriptionController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController applicationMessageController = TextEditingController();

  // ===================== VARIABLES =====================
  String? contractType;
  DateTime? selectedDate;

  // ===================== CRITICAL FIX: SEPARATE DATA STORAGE =====================
  List<JobModel> _allUserJobs = [];
  List<JobModel> _allVendorJobs = [];

  // Vendor cache
  Map<String, UserModel> vendorCache = {};

  // User specific data
  List<Map<String, dynamic>> appliedJobs = [];
  List<Map<String, dynamic>> savedJobs = [];
  bool isLoadingAppliedJobs = false;
  bool isLoadingSavedJobs = false;

  @override
  void onInit() {
    super.onInit();
    _loadDataBasedOnUserType();
  }

  // ===================== PRIVATE FUNCTION: USER TYPE CHECK =====================
  void _loadDataBasedOnUserType() {
    if (currentUser.userType == 1) { // USER
      loadJobs();
      loadSavedJobs();
      loadAppliedJobs();
    } else if (currentUser.userType == 2) { // VENDOR
      loadVendorJobs();
    }
  }

  // ===================== USER SIDE - JOB APPLICATIONS =====================
  Future<void> loadAppliedJobs() async {
    if (isLoadingAppliedJobs) return;

    isLoadingAppliedJobs = true;
    update();

    try {
      appliedJobs = await FirestoreServices.I.getUserJobApplications(
        currentUser.id,
      );
      if (kDebugMode) print(" Loaded ${appliedJobs.length} applications");
    } catch (e) {
      if (kDebugMode) print(" Error loading applied jobs: $e");
      appliedJobs = [];
    }

    isLoadingAppliedJobs = false;
    update();
  }

  bool hasUserApplied(String jobId) {
    for (var app in appliedJobs) {
      if (app['application']['jobId'] == jobId) {
        return true;
      }
    }
    return false;
  }

  bool canWithdrawApplication(String jobId) {
    for (var app in appliedJobs) {
      if (app['application']['jobId'] == jobId &&
          app['application']['status'] == 'pending') {
        return true;
      }
    }
    return false;
  }

  Map<String, dynamic>? getApplicationForJob(String jobId) {
    for (var app in appliedJobs) {
      if (app['application']['jobId'] == jobId) {
        return app['application'];
      }
    }
    return null;
  }

  Future<void> applyForJob(JobModel job) async {
    if (hasUserApplied(job.id)) {
      EasyLoading.showInfo("You have already applied for this job");
      return;
    }

    if (applicationMessageController.text.isEmpty) {
      EasyLoading.showInfo("Please write a message");
      return;
    }

    if (applicationMessageController.text.length < 10) {
      EasyLoading.showInfo("Please write at least 10 characters");
      return;
    }

    EasyLoading.show(status: "Applying...");

    try {
      await FirestoreServices.I.addJobApplication(
        jobId: job.id,
        userId: currentUser.id,
        userName: "${currentUser.firstName} ${currentUser.lastName}",
        userImage: currentUser.images.isNotEmpty ? currentUser.images[0] : "",
        message: applicationMessageController.text,
        appliedAt: DateTime.now(),
      );

      applicationMessageController.clear();
      await loadAppliedJobs();
      EasyLoading.showSuccess("Application submitted!");
      Navigator.of(Get.context!).pop();
      Get.offAll(() => JobsAppliedPage());
    } catch (e) {
      EasyLoading.showError("Failed to apply: $e");
    }
  }

  // ===================== USER SIDE - WITHDRAWAL =====================
  Future<void> withdrawApplication(String applicationId, String jobId) async {
    EasyLoading.show(status: "Withdrawing...");

    try {
      bool success = await FirestoreServices.I.updateJobApplicationStatus(
        applicationId: applicationId,
        status: 'withdrawn',
        withdrawnAt: DateTime.now(),
      );

      if (success) {
        await loadAppliedJobs();
        EasyLoading.showSuccess("Application withdrawn!");

        if (Get.isDialogOpen ?? false) Get.back();
        if (Navigator.canPop(Get.context!)) Get.back();
      } else {
        EasyLoading.showError("Failed to withdraw application");
      }
    } catch (e) {
      EasyLoading.showError("Failed to withdraw: $e");
    }
  }

  // ===================== USER SIDE - JOB DISPLAY =====================
  Map<String, List<JobModel>> getJobsGroupedByAddress() {
    Map<String, List<JobModel>> groupedJobs = {};
    String userCity = currentUser.city;

    List<JobModel> cityJobs = _allUserJobs
        .where((job) => job.isActive && job.vendorCity == userCity)
        .toList();

    for (var job in cityJobs) {
      String addressKey = job.vendorAddress.isNotEmpty
          ? job.vendorAddress
          : job.vendorCity;

      if (!groupedJobs.containsKey(addressKey)) {
        groupedJobs[addressKey] = [];
      }
      groupedJobs[addressKey]!.add(job);
    }

    return groupedJobs;
  }

  // ===================== SAVED JOBS FUNCTIONS =====================
  Future<void> loadSavedJobs() async {
    if (isLoadingSavedJobs) return;

    isLoadingSavedJobs = true;
    update();

    try {
      savedJobs = await FirestoreServices.I.getSavedJobsForUser(currentUser.id);
      if (kDebugMode) print(" Loaded ${savedJobs.length} saved jobs");
    } catch (e) {
      if (kDebugMode) print(" Error loading saved jobs: $e");
      savedJobs = [];
    }

    isLoadingSavedJobs = false;
    update();
  }

  Future<void> toggleJobSaveStatus(JobModel job) async {
    try {
      bool isCurrentlySaved = await FirestoreServices.I.isJobSaved(
        jobId: job.id,
        userId: currentUser.id,
      );

      if (isCurrentlySaved) {
        await FirestoreServices.I.removeSavedJob(
          jobId: job.id,
          userId: currentUser.id,
        );
        if (kDebugMode) print(" Job unsaved: ${job.id}");
      } else {
        await FirestoreServices.I.saveJobForUser(
          jobId: job.id,
          userId: currentUser.id,
          vendorId: job.vendorId,
          vendorName: job.vendorName,
          vendorImage: job.vendorImage,
          jobTitle: job.title,
          contractType: job.contractType,
          hoursPerWeek: job.hoursPerWeek,
        );
        if (kDebugMode) print(" Job saved: ${job.id}");
      }

      await loadSavedJobs();
      update();
    } catch (e) {
      if (kDebugMode) print(" Error toggling save status: $e");
    }
  }

  bool isJobCurrentlySaved(String jobId) {
    for (var savedJob in savedJobs) {
      if (savedJob['savedJob']['jobId'] == jobId) {
        return true;
      }
    }
    return false;
  }

  // ===================== VENDOR SIDE - JOB MANAGEMENT =====================
  Future<void> addJob(bool isActive) async {
    if (titleController.text.isEmpty) {
      EasyLoading.showInfo("Please enter job title");
      return;
    }
    if (contractType == null) {
      EasyLoading.showInfo("Please select contract type");
      return;
    }
    if (coefficientController.text.isEmpty) {
      EasyLoading.showInfo("Please enter coefficient");
      return;
    }
    if (selectedDate == null) {
      EasyLoading.showInfo("Please select start date");
      return;
    }
    if (roleDescriptionController.text.isEmpty) {
      EasyLoading.showInfo("Please enter role description");
      return;
    }
    if (hoursController.text.isEmpty) {
      EasyLoading.showInfo("Please enter hours per week");
      return;
    }

    EasyLoading.show(status: "Saving job...");

    JobModel newJob = JobModel()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..vendorId = currentUser.id
      ..vendorName = currentUser.firstName
      ..vendorImage = currentUser.images.isNotEmpty ? currentUser.images[0] : ""
      ..vendorAddress = currentUser.address
      ..vendorCity = currentUser.city
      ..vendorCountry = currentUser.country
      ..title = titleController.text
      ..contractType = contractType!
      ..coefficient = coefficientController.text
      ..startDate = selectedDate!
      ..roleDescription = roleDescriptionController.text
      ..hoursPerWeek = hoursController.text
      ..isActive = isActive
      ..createdAt = DateTime.now();

    try {
      await FirestoreServices.I.addJob(newJob);

      if (currentUser.userType == 2) {
        await loadVendorJobs();
      }

      clearFields();
      EasyLoading.showSuccess(
        isActive ? "Job published" : "Job saved as draft",
      );
      Get.back();
    } catch (e) {
      EasyLoading.showError("Failed to save job");
    }
  }

  Future<void> loadVendorJobs() async {
    if (currentUser.userType != 2) return;

    try {
      _allVendorJobs = await FirestoreServices.I.getVendorJobs(currentUser.id);

      _allVendorJobs = _allVendorJobs.where((job) =>
      job.vendorId == currentUser.id
      ).toList();

      update();
    } catch (e) {
      _allVendorJobs = [];
      update();
    }
  }

  List<JobModel> get allJobs {
    if (currentUser.userType == 1) {
      return _allUserJobs;
    } else {
      return _allVendorJobs;
    }
  }

  List<JobModel> get activeJobs {
    if (currentUser.userType == 1) {
      return _allUserJobs.where((job) => job.isActive).toList();
    } else {
      return _allVendorJobs.where((job) => job.isActive).toList();
    }
  }

  List<JobModel> get inactiveJobs {
    if (currentUser.userType == 1) {
      return _allUserJobs.where((job) => !job.isActive).toList();
    } else {
      return _allVendorJobs.where((job) => !job.isActive).toList();
    }
  }

  List<JobModel> getJobsForVendor(String vendorId) {
    if (currentUser.userType == 2) {
      return _allVendorJobs
          .where((job) => job.isActive && job.vendorId == vendorId)
          .toList();
    } else {
      return _allUserJobs
          .where((job) => job.isActive && job.vendorId == vendorId)
          .toList();
    }
  }

  List<JobModel> getJobsByType(String type, String vendorId) {
    List<JobModel> vendorJobs = getJobsForVendor(vendorId);
    if (type == "All Jobs") return vendorJobs;
    return vendorJobs
        .where(
          (job) => job.contractType.toLowerCase().contains(type.toLowerCase()),
    )
        .toList();
  }

  // ===================== COMMON FUNCTIONS =====================
  Future<void> loadJobs() async {
    if (currentUser.userType != 1) return;

    try {
      _allUserJobs = await FirestoreServices.I.getAllActiveJobs();

      _allUserJobs = _allUserJobs.where((job) =>
      job.isActive && job.vendorCity == currentUser.city
      ).toList();

      update();
    } catch (e) {
      _allUserJobs = [];
      update();
    }
  }

  Future<UserModel> getVendorData(String vendorId) async {
    if (vendorCache.containsKey(vendorId)) return vendorCache[vendorId]!;
    UserModel vendor = await FirestoreServices.I.getUser(vendorId);
    vendorCache[vendorId] = vendor;
    return vendor;
  }

  void clearFields() {
    titleController.clear();
    contractType = null;
    coefficientController.clear();
    roleDescriptionController.clear();
    hoursController.clear();
    selectedDate = null;
  }

  bool hasJobsInUserCity() {
    if (currentUser.userType != 1) return false;

    String userCity = currentUser.city;
    return _allUserJobs.any((job) => job.isActive && job.vendorCity == userCity);
  }
}