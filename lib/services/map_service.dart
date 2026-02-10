import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:linkpharma/models/job_model.dart';

class MapServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<JobModel>> getJobsByCity({
    required String country,
    required String city,
  }) async {
    try {
      String cleanCountry = country.trim().toLowerCase();
      String cleanCity = city.trim().toLowerCase();

      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true);

      final snapshot = await query.get();

      List<JobModel> jobs = [];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            final jobData = Map<String, dynamic>.from(data);
            jobData['id'] = doc.id;

            String jobCountry = (jobData['vendorCountry'] ?? '')
                .toString()
                .trim()
                .toLowerCase();
            String jobCity = (jobData['vendorCity'] ?? '')
                .toString()
                .trim()
                .toLowerCase();

            if (jobCountry == cleanCountry && jobCity == cleanCity) {
              jobs.add(JobModel.fromJson(jobData));
            }
          }
        } catch (e) {
          continue;
        }
      }

      return jobs;
    } catch (e) {
      if (kDebugMode) {
        print('Error in getJobsByCity: $e');
      }
      return [];
    }
  }

  Future<Map<String, dynamic>> searchPlaceAndJobs({
    required String placeName,
  }) async {
    try {
      if (kDebugMode) {
        print('\n🌍 SEARCHING PLACE: "$placeName"');
      }

      String cleanPlaceName = placeName.trim().toLowerCase();

      List<JobModel> jobs = await _getJobsByPlaceName(cleanPlaceName);
      if (kDebugMode) {
        print('Found ${jobs.length} jobs for "$placeName"');
      }

      Map<String, double> coordinates = await _getPlaceCoordinates(placeName);
      if (kDebugMode) {
        print(
          ' Place coordinates: ${coordinates['lat']}, ${coordinates['lng']}',
        );
      }

      return {
        'jobs': jobs,
        'lat': coordinates['lat'],
        'lng': coordinates['lng'],
        'hasJobs': jobs.isNotEmpty,
        'placeName': placeName,
      };
    } catch (e) {
      if (kDebugMode) {
        print(' Error in searchPlaceAndJobs: $e');
      }
      return {
        'jobs': [],
        'lat': 0.0,
        'lng': 0.0,
        'hasJobs': false,
        'placeName': placeName,
      };
    }
  }

  Future<List<JobModel>> _getJobsByPlaceName(String placeName) async {
    try {
      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true);

      final snapshot = await query.get();
      List<JobModel> jobs = [];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            final jobData = Map<String, dynamic>.from(data);
            jobData['id'] = doc.id;

            String vendorCity = (jobData['vendorCity'] ?? '')
                .toString()
                .trim()
                .toLowerCase();

            if (vendorCity == placeName) {
              jobs.add(JobModel.fromJson(jobData));
            } else if (vendorCity.contains(placeName)) {
              jobs.add(JobModel.fromJson(jobData));
            }
          }
        } catch (e) {
          continue;
        }
      }

      return jobs;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting jobs by place: $e');
      }
      return [];
    }
  }

  Future<Map<String, double>> _getPlaceCoordinates(String placeName) async {
    try {
      if (kDebugMode) {
        print('Geocoding place: "$placeName"');
      }
      List<geo.Location> locations = await geo.locationFromAddress(placeName);

      if (locations.isNotEmpty) {
        double lat = locations[0].latitude;
        double lng = locations[0].longitude;
        if (kDebugMode) {
          print('Geocoded: $lat, $lng');
        }
        return {'lat': lat, 'lng': lng};
      } else {
        if (kDebugMode) {
          print('Geocoding returned empty');
        }
        return {'lat': 0.0, 'lng': 0.0};
      }
    } catch (e) {
      if (kDebugMode) {
        print('Geocoding error: $e');
      }
      return {'lat': 20.0, 'lng': 0.0};
    }
  }

  Future<List<String>> getAllCitiesForCountry(String country) async {
    try {
      String cleanCountry = country.trim().toLowerCase();
      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true);

      final snapshot = await query.get();

      Set<String> cities = {};

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            String jobCountry = (data['vendorCountry'] ?? '')
                .toString()
                .trim()
                .toLowerCase();
            String jobCity = (data['vendorCity'] ?? '').toString().trim();

            if (jobCountry == cleanCountry && jobCity.isNotEmpty) {
              cities.add(jobCity);
            }
          }
        } catch (e) {
          continue;
        }
      }

      return cities.toList()..sort();
    } catch (e) {
      if (kDebugMode) {
        print(' Error getting cities: $e');
      }
      return [];
    }
  }

  Future<List<JobModel>> filterJobs({
    required String? selectedCountry,
    required String? selectedCity,
    required List<String> selectedJobTypes,
    required DateTime? startDate,
  }) async {
    try {
      String? cleanCountry = selectedCountry?.trim().toLowerCase();
      String? cleanCity = selectedCity?.trim().toLowerCase();

      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true);

      final snapshot = await query.get();

      List<JobModel> filteredJobs = [];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            final jobData = Map<String, dynamic>.from(data);
            jobData['id'] = doc.id;

            String jobCountry = (jobData['vendorCountry'] ?? '')
                .toString()
                .trim()
                .toLowerCase();
            String jobCity = (jobData['vendorCity'] ?? '')
                .toString()
                .trim()
                .toLowerCase();

            if (cleanCountry != null && cleanCountry.isNotEmpty) {
              if (jobCountry != cleanCountry) {
                continue;
              }
            }

            if (cleanCity != null && cleanCity.isNotEmpty) {
              if (jobCity != cleanCity) {
                continue;
              }
            }

            if (selectedJobTypes.isNotEmpty) {
              String jobContractType = (jobData['contractType'] ?? '')
                  .toString()
                  .trim()
                  .toLowerCase();
              bool typeMatches = false;
              for (var type in selectedJobTypes) {
                if (jobContractType.contains(type.toLowerCase())) {
                  typeMatches = true;
                  break;
                }
              }
              if (!typeMatches) {
                continue;
              }
            }

            if (startDate != null) {
              String startDateStr = jobData['startDate'] ?? '';
              if (startDateStr.isNotEmpty) {
                DateTime jobStartDate = DateTime.parse(startDateStr);
                if (jobStartDate.isBefore(startDate)) {
                  continue;
                }
              }
            }

            filteredJobs.add(JobModel.fromJson(jobData));
          }
        } catch (e) {
          continue;
        }
      }

      filteredJobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return filteredJobs;
    } catch (e) {
      if (kDebugMode) {
        print(' Error in filterJobs: $e');
      }
      return [];
    }
  }

  Future<List<String>> getAllCitiesWithJobs() async {
    try {
      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true);

      final snapshot = await query.get();

      Set<String> cities = {};

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            String jobCity = (data['vendorCity'] ?? '').toString().trim();
            String jobCountry = (data['vendorCountry'] ?? '').toString().trim();

            if (jobCity.isNotEmpty && jobCountry.isNotEmpty) {
              cities.add("$jobCity, $jobCountry");
            }
          }
        } catch (e) {
          continue;
        }
      }

      return cities.toList()..sort();
    } catch (e) {
      if (kDebugMode) {
        print(' Error in getAllCitiesWithJobs: $e');
      }
      return [];
    }
  }

  Future<List<String>> getAllCountriesWithJobs() async {
    try {
      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true);

      final snapshot = await query.get();

      Set<String> countries = {};

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            String jobCountry = (data['vendorCountry'] ?? '').toString().trim();
            if (jobCountry.isNotEmpty) {
              countries.add(jobCountry);
            }
          }
        } catch (e) {
          continue;
        }
      }

      return countries.toList()..sort();
    } catch (e) {
      if (kDebugMode) {
        print('Error in getAllCountriesWithJobs: $e');
      }
      return [];
    }
  }

  Future<List<String>> getCitiesForCountry(String country) async {
    try {
      print('🔍 getCitiesForCountry called with: "$country"');

      String cleanCountry = country.trim().toLowerCase();
      print('   Clean country: "$cleanCountry"');

      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true);

      final snapshot = await query.get();
      print('   Total active jobs: ${snapshot.docs.length}');

      Set<String> cities = {};
      int matchCount = 0;

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            String jobCountry = (data['vendorCountry'] ?? '')
                .toString()
                .trim()
                .toLowerCase();
            String jobCity = (data['vendorCity'] ?? '').toString().trim();

            print('   Job: Country="$jobCountry", City="$jobCity"');

            if (jobCountry == cleanCountry && jobCity.isNotEmpty) {
              cities.add(jobCity);
              matchCount++;
              print(' MATCHED!');
            }
          }
        } catch (e) {
          print('   Error: $e');
          continue;
        }
      }

      List<String> result = cities.toList()..sort();
      print('   Total matched: $matchCount');
      print('   Unique cities: ${result.length}');
      print('   Cities: $result');
      print('');

      return result;
    } catch (e) {
      print('❌ Error in getCitiesForCountry: $e');
      return [];
    }
  }
}