import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkpharma/models/job_model.dart';

class MapServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Get jobs by country AND city
  Future<List<JobModel>> getJobsByCity({
    required String country,
    required String city,
  }) async {
    try {
      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .where('vendorCountry', isEqualTo: country.trim())
          .where('vendorCity', isEqualTo: city.trim());

      final snapshot = await query.get();
      return _convertDocsToJobs(snapshot.docs);
    } catch (e) {
      print("Error in getJobsByCity: $e");
      return [];
    }
  }

  /// ✅ FIXED: Search jobs by city name only (cross-country search)
  Future<List<JobModel>> getJobsByCityName({
    required String cityName,
  }) async {
    try {
      // Search across all countries for this city
      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .where('vendorCity', isEqualTo: cityName.trim());

      final snapshot = await query.get();
      List<JobModel> jobs = _convertDocsToJobs(snapshot.docs);

      // If no results, try case-insensitive search (client-side)
      if (jobs.isEmpty) {
        return await _searchJobsByCityInsensitive(cityName.trim());
      }

      return jobs;
    } catch (e) {
      print("Error in getJobsByCityName: $e");
      return [];
    }
  }

  /// ✅ NEW: Case-insensitive search fallback
  Future<List<JobModel>> _searchJobsByCityInsensitive(String cityName) async {
    try {
      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true);

      final snapshot = await query.get();

      List<JobModel> jobs = _convertDocsToJobs(snapshot.docs);

      // Filter client-side for case-insensitive match
      return jobs.where((job) =>
          job.vendorCity.toLowerCase().contains(cityName.toLowerCase())
      ).toList();
    } catch (e) {
      print("Error in case-insensitive search: $e");
      return [];
    }
  }

  /// ✅ NEW: Get all cities for suggestions
  Future<List<String>> getAllCitiesForCountry(String country) async {
    try {
      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .where('vendorCountry', isEqualTo: country.trim());

      final snapshot = await query.get();

      Set<String> cities = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['vendorCity'] != null) {
          cities.add(data['vendorCity'].toString().trim());
        }
      }

      return cities.toList()..sort();
    } catch (e) {
      print("Error getting cities: $e");
      return [];
    }
  }

  List<JobModel> _convertDocsToJobs(List<QueryDocumentSnapshot> docs) {
    List<JobModel> jobs = [];

    for (var doc in docs) {
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
  }
}