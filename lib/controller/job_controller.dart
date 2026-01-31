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
  List<JobModel> allJobs = [];
  Map<String, UserModel> vendorCache = {};
  List<Map<String, dynamic>> appliedJobs = [];
  bool isLoadingAppliedJobs = false;

  @override
  void onInit() {
    super.onInit();
    loadJobs();
    loadSavedJobs();
    loadAppliedJobs();
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

    List<JobModel> cityJobs = allJobs
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
  List<Map<String, dynamic>> savedJobs = [];
  bool isLoadingSavedJobs = false;

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
      await loadVendorJobs();
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
    allJobs = await FirestoreServices.I.getVendorJobs(currentUser.id);
    update();
  }

  List<JobModel> getJobsForVendor(String vendorId) {
    return allJobs
        .where((job) => job.isActive && job.vendorId == vendorId)
        .toList();
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
    allJobs = await FirestoreServices.I.getAllActiveJobs();
    update();
  }

  Future<UserModel> getVendorData(String vendorId) async {
    if (vendorCache.containsKey(vendorId)) return vendorCache[vendorId]!;
    UserModel vendor = await FirestoreServices.I.getUser(vendorId);
    vendorCache[vendorId] = vendor;
    return vendor;
  }

  List<JobModel> get activeJobs =>
      allJobs.where((job) => job.isActive).toList();
  List<JobModel> get inactiveJobs =>
      allJobs.where((job) => !job.isActive).toList();

  void clearFields() {
    titleController.clear();
    contractType = null;
    coefficientController.clear();
    roleDescriptionController.clear();
    hoursController.clear();
    selectedDate = null;
  }

  bool hasJobsInUserCity() {
    String userCity = currentUser.city;
    return allJobs.any((job) => job.isActive && job.vendorCity == userCity);
  }
}