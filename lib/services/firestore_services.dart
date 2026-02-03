import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/models/user_model.dart';
import '../models/job_model.dart';

class FirestoreServices {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static final FirestoreServices I = FirestoreServices._();
  FirestoreServices._();

  // ===================== USER RELATED FUNCTIONS =====================
  Future<UserModel> getUser(String id) async {
    try {
      DocumentSnapshot doc = await _instance.collection("users").doc(id).get();
      if (!doc.exists) return UserModel();

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return UserModel();

      UserModel user = UserModel.fromJson(data);

      // COUNTRY TRIM: Agar existing user ka country mein space hai
      if (user.country != user.country.trim()) {
        user.country = user.country.trim();
      }

      logger.i(user.toJson());
      return user;
    } catch (e) {
      logger.e("Error getting user: $e");
      return UserModel();
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      user.country = user.country.trim();

      await _instance.collection("users").doc(user.id).set(user.toJson());
    } catch (e) {
      logger.e("Error adding user: $e");
      rethrow;
    }
  }

  // ===================== USER - JOB APPLICATIONS =====================
  Future<List<Map<String, dynamic>>> getUserJobApplications(
    String userId,
  ) async {
    try {
      final snapshot = await _instance
          .collection('jobApplications')
          .where('userId', isEqualTo: userId)
          .orderBy('appliedAt', descending: true)
          .get();

      List<Map<String, dynamic>> applications = [];

      for (var doc in snapshot.docs) {
        final applicationData = doc.data();
        final jobDoc = await _instance
            .collection('jobs')
            .doc(applicationData['jobId'])
            .get();

        if (jobDoc.exists) {
          final jobData = jobDoc.data();
          if (jobData != null) {
            jobData['id'] = doc.id;
            final job = JobModel.fromJson(jobData);

            if (job.isActive) {
              applications.add({'application': applicationData, 'job': job});
            }
          }
        }
      }

      return applications;
    } catch (e) {
      if (kDebugMode) print("Error getting user applications: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getJobApplicationByJobAndUser(
    String jobId,
    String userId,
  ) async {
    try {
      final snapshot = await _instance
          .collection('jobApplications')
          .where('jobId', isEqualTo: jobId)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Error getting application: $e");
      return null;
    }
  }

  // ===================== APPLICATION STATUS MANAGEMENT =====================
  Future<void> addJobApplication({
    required String jobId,
    required String userId,
    required String userName,
    required String userImage,
    required String message,
    required DateTime appliedAt,
  }) async {
    try {
      final applicationId = DateTime.now().millisecondsSinceEpoch.toString();

      await _instance.collection('jobApplications').doc(applicationId).set({
        'id': applicationId,
        'jobId': jobId,
        'userId': userId,
        'userName': userName,
        'userImage': userImage,
        'message': message,
        'appliedAt': appliedAt.toIso8601String(),
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
        'withdrawnAt': null,
        'rejectedAt': null,
        'acceptedAt': null,
        'interviewScheduledAt': null,
        'updatedAt': null,
      });
    } catch (e) {
      if (kDebugMode) print("Firestore error: $e");
      rethrow;
    }
  }

  Future<bool> updateJobApplicationStatus({
    required String applicationId,
    required String status,
    DateTime? withdrawnAt,
    DateTime? rejectedAt,
    DateTime? acceptedAt,
    DateTime? interviewScheduledAt,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'status': status,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (withdrawnAt != null) {
        updateData['withdrawnAt'] = withdrawnAt.toIso8601String();
      }
      if (rejectedAt != null) {
        updateData['rejectedAt'] = rejectedAt.toIso8601String();
      }
      if (acceptedAt != null) {
        updateData['acceptedAt'] = acceptedAt.toIso8601String();
      }
      if (interviewScheduledAt != null) {
        updateData['interviewScheduledAt'] = interviewScheduledAt
            .toIso8601String();
      }

      await _instance
          .collection('jobApplications')
          .doc(applicationId)
          .update(updateData);
      return true;
    } catch (e) {
      if (kDebugMode) print("Error updating application status: $e");
      return false;
    }
  }

  // ===================== VENDOR - JOB MANAGEMENT =====================
  Future<void> addJob(JobModel job) async {
    try {
      job.vendorCountry = job.vendorCountry.trim();

      await _instance.collection('jobs').doc(job.id).set(job.toJson());
    } catch (e) {
      logger.e("Error adding job: $e");
      rethrow;
    }
  }

  Future<List<JobModel>> getVendorJobs(String vendorId) async {
    try {
      final snapshot = await _instance
          .collection('jobs')
          .where('vendorId', isEqualTo: vendorId)
          .get();

      List<JobModel> jobs = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          final jobData = Map<String, dynamic>.from(data);
          jobData['id'] = doc.id;

          // COUNTRY TRIM: Agar job data mein space hai
          if (jobData['vendorCountry'] != null) {
            jobData['vendorCountry'] = jobData['vendorCountry']
                .toString()
                .trim();
          }

          jobs.add(JobModel.fromJson(jobData));
        }
      }

      jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return jobs;
    } catch (e) {
      logger.e("Error getting vendor jobs: $e");
      return [];
    }
  }

  Stream<List<JobModel>> getVendorJobsStream(String vendorId) {
    return _instance
        .collection('jobs')
        .where('vendorId', isEqualTo: vendorId)
        .snapshots()
        .map((snapshot) {
          List<JobModel> jobs = [];

          for (var doc in snapshot.docs) {
            final data = doc.data() as Map<String, dynamic>?;
            if (data != null) {
              final jobData = Map<String, dynamic>.from(data);
              jobData['id'] = doc.id;

              // COUNTRY TRIM
              if (jobData['vendorCountry'] != null) {
                jobData['vendorCountry'] = jobData['vendorCountry']
                    .toString()
                    .trim();
              }

              jobs.add(JobModel.fromJson(jobData));
            }
          }

          jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return jobs;
        });
  }

  // ===================== PUBLIC JOB FUNCTIONS (USER SIDE) =====================
  Future<List<JobModel>> getAllActiveJobs() async {
    try {
      final querySnapshot = await _instance
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .get();

      List<JobModel> jobs = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          final jobData = Map<String, dynamic>.from(data);
          jobData['id'] = doc.id;

          // COUNTRY TRIM
          if (jobData['vendorCountry'] != null) {
            jobData['vendorCountry'] = jobData['vendorCountry']
                .toString()
                .trim();
          }

          jobs.add(JobModel.fromJson(jobData));
        }
      }

      return jobs;
    } catch (e) {
      logger.e("Error getting all active jobs: $e");
      return [];
    }
  }

  // ===================== IMPORTANT: JOBS BY COUNTRY WITH TRIM =====================
  Future<List<JobModel>> getJobsByCountry({
    required String country,
    int limit = 10,
    JobModel? lastDocument,
  }) async {
    try {
      // COUNTRY TRIM: Query mein bhi trim karo
      String cleanCountry = country.trim();

      Query query = _instance
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .where(
            'vendorCountry',
            isEqualTo: cleanCountry,
          ) // <-- TRIMMED COUNTRY
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        final lastDoc = await _instance
            .collection('jobs')
            .doc(lastDocument.id)
            .get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final querySnapshot = await query.get();

      List<JobModel> jobs = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          final jobData = Map<String, dynamic>.from(data);
          jobData['id'] = doc.id;

          // COUNTRY TRIM: Job data mein bhi trim karo
          if (jobData['vendorCountry'] != null) {
            jobData['vendorCountry'] = jobData['vendorCountry']
                .toString()
                .trim();
          }

          jobs.add(JobModel.fromJson(jobData));
        }
      }

      return jobs;
    } catch (e) {
      logger.e("Error getting jobs by country: $e");
      return [];
    }
  }

  // ===================== VENDOR - APPLICATION VIEWING =====================
  Future<List<Map<String, dynamic>>> getJobApplicationsForVendor(
    String vendorId,
  ) async {
    try {
      final jobDocs = await _instance
          .collection('jobs')
          .where('vendorId', isEqualTo: vendorId)
          .get();

      List<String> jobIds = [];

      for (var doc in jobDocs.docs) {
        jobIds.add(doc.id);
      }

      if (jobIds.isEmpty) return [];

      final applicationSnapshot = await _instance
          .collection('jobApplications')
          .where('jobId', whereIn: jobIds)
          .where('status', isEqualTo: 'pending')
          .orderBy('appliedAt', descending: true)
          .get();

      List<Map<String, dynamic>> applications = [];

      for (var doc in applicationSnapshot.docs) {
        final applicationData = doc.data();
        final jobDoc = await _instance
            .collection('jobs')
            .doc(applicationData['jobId'])
            .get();

        if (jobDoc.exists) {
          final jobData = jobDoc.data();
          if (jobData != null) {
            final jobDataWithId = Map<String, dynamic>.from(jobData);
            jobDataWithId['id'] = jobDoc.id;

            // COUNTRY TRIM
            if (jobDataWithId['vendorCountry'] != null) {
              jobDataWithId['vendorCountry'] = jobDataWithId['vendorCountry']
                  .toString()
                  .trim();
            }

            final job = JobModel.fromJson(jobDataWithId);

            if (job.isActive) {
              applications.add({'application': applicationData, 'job': job});
            }
          }
        }
      }

      return applications;
    } catch (e) {
      if (kDebugMode) print("Error getting vendor applications: $e");
      return [];
    }
  }

  // ===================== SAVED JOBS FUNCTIONS =====================
  Future<void> saveJobForUser({
    required String jobId,
    required String userId,
    required String vendorId,
    required String vendorName,
    required String vendorImage,
    required String jobTitle,
    required String contractType,
    required String hoursPerWeek,
  }) async {
    try {
      final savedJobId = '${userId}_$jobId';

      await _instance.collection('savedJobs').doc(savedJobId).set({
        'id': savedJobId,
        'jobId': jobId,
        'userId': userId,
        'vendorId': vendorId,
        'vendorName': vendorName,
        'vendorImage': vendorImage,
        'jobTitle': jobTitle,
        'contractType': contractType,
        'hoursPerWeek': hoursPerWeek,
        'savedAt': DateTime.now().toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (kDebugMode) print("Error saving job: $e");
      rethrow;
    }
  }

  Future<void> removeSavedJob({
    required String jobId,
    required String userId,
  }) async {
    try {
      final savedJobId = '${userId}_$jobId';
      await _instance.collection('savedJobs').doc(savedJobId).delete();
    } catch (e) {
      if (kDebugMode) print("Error removing saved job: $e");
      rethrow;
    }
  }

  Future<bool> isJobSaved({
    required String jobId,
    required String userId,
  }) async {
    try {
      final savedJobId = '${userId}_$jobId';
      final doc = await _instance.collection('savedJobs').doc(savedJobId).get();
      return doc.exists;
    } catch (e) {
      if (kDebugMode) print("Error checking saved job: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getSavedJobsForUser(String userId) async {
    try {
      final snapshot = await _instance
          .collection('savedJobs')
          .where('userId', isEqualTo: userId)
          .orderBy('savedAt', descending: true)
          .get();

      List<Map<String, dynamic>> savedJobs = [];

      for (var doc in snapshot.docs) {
        final savedJobData = doc.data();
        final jobDoc = await _instance
            .collection('jobs')
            .doc(savedJobData['jobId'])
            .get();

        if (jobDoc.exists) {
          final jobData = jobDoc.data();
          if (jobData != null) {
            final jobDataWithId = Map<String, dynamic>.from(jobData);
            jobDataWithId['id'] = jobDoc.id;

            // COUNTRY TRIM
            if (jobDataWithId['vendorCountry'] != null) {
              jobDataWithId['vendorCountry'] = jobDataWithId['vendorCountry']
                  .toString()
                  .trim();
            }

            final job = JobModel.fromJson(jobDataWithId);

            savedJobs.add({'savedJob': savedJobData, 'job': job});
          }
        }
      }

      return savedJobs;
    } catch (e) {
      if (kDebugMode) print("Error getting saved jobs: $e");
      return [];
    }
  }

  // ===================== CONTACT MESSAGES FUNCTIONS =====================
  Future<bool> submitContactMessage({
    required String userId,
    required String userType,
    required String name,
    required String email,
    required String subject,
    required String description,
  }) async {
    try {
      final messageId = DateTime.now().millisecondsSinceEpoch.toString();

      await _instance.collection('contactMessages').doc(messageId).set({
        'id': messageId,
        'userId': userId,
        'userType': userType,
        'name': name,
        'email': email,
        'subject': subject,
        'description': description,
        'createdAt': DateTime.now().toIso8601String(),
        'status': 'pending',
        'repliedAt': null,
      });

      return true;
    } catch (e) {
      if (kDebugMode) print("Error submitting contact message: $e");
      return false;
    }
  }




// ===================== VENDOR JOB FUNCTIONS =====================

  /// Get job by ID
  Future<JobModel?> getVendorJobById(String jobId) async {
    try {
      final doc = await _instance.collection('jobs').doc(jobId).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          final jobData = Map<String, dynamic>.from(data);
          jobData['id'] = doc.id;
          return JobModel.fromJson(jobData);
        }
      }
      return null;
    } catch (e) {
      logger.e("Error getting vendor job: $e");
      return null;
    }
  }

  /// Get applications for specific job
  Future<List<Map<String, dynamic>>> getVendorJobApplications(String jobId) async {
    try {
      final snapshot = await _instance
          .collection('jobApplications')
          .where('jobId', isEqualTo: jobId)
          .where('status', isEqualTo: 'pending')
          .get();

      List<Map<String, dynamic>> applications = [];

      for (var doc in snapshot.docs) {
        final appData = doc.data();
        final user = await getUser(appData['userId']);

        applications.add({
          'id': doc.id,
          'appData': appData,
          'user': user,
        });
      }

      return applications;
    } catch (e) {
      logger.e("Error getting vendor applications: $e");
      return [];
    }
  }

  /// Update job status
  Future<bool> updateVendorJobStatus(String jobId, bool isActive) async {
    try {
      await _instance
          .collection('jobs')
          .doc(jobId)
          .update({'isActive': isActive});
      return true;
    } catch (e) {
      logger.e("Error updating job status: $e");
      return false;
    }
  }

}
