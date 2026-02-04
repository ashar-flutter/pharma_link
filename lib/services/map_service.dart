import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkpharma/models/job_model.dart';

class MapServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<JobModel>> getMapJobs(String country, {String? city}) async {
    try {
      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .where('vendorCountry', isEqualTo: country.trim());

      if (city != null && city.isNotEmpty) {
        query = query.where('vendorCity', isEqualTo: city.trim());
      }

      final snapshot = await query.get();

      List<JobModel> jobs = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          final jobData = Map<String, dynamic>.from(data);
          jobData['id'] = doc.id;

          if (jobData['vendorCountry'] != null) {
            jobData['vendorCountry'] = jobData['vendorCountry'].toString().trim();
          }

          jobs.add(JobModel.fromJson(jobData));
        }
      }

      return jobs;
    } catch (e) {
      return [];
    }
  }

  Future<List<JobModel>> getFilteredJobs({
    required String country,
    String? city,
    List<String>? contractTypes,
    DateTime? startDate,
  }) async {
    try {
      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .where('vendorCountry', isEqualTo: country.trim());

      if (city != null && city.isNotEmpty) {
        query = query.where('vendorCity', isEqualTo: city.trim());
      }

      if (contractTypes != null && contractTypes.isNotEmpty) {
        query = query.where('contractType', whereIn: contractTypes);
      }

      if (startDate != null) {
        query = query.where('startDate', isGreaterThanOrEqualTo: startDate);
      }

      final snapshot = await query.get();

      List<JobModel> jobs = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          final jobData = Map<String, dynamic>.from(data);
          jobData['id'] = doc.id;

          if (jobData['vendorCountry'] != null) {
            jobData['vendorCountry'] = jobData['vendorCountry'].toString().trim();
          }

          jobs.add(JobModel.fromJson(jobData));
        }
      }

      return jobs;
    } catch (e) {
      return [];
    }
  }

  Future<void> updateJobLocation(String jobId, double lat, double lng) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'vendorLat': lat,
        'vendorLng': lng,
      });
    } catch (e) {
      rethrow;
    }
  }
}