class JobModel {
  String id = "";
  String vendorId = "";
  String vendorName = "";
  String vendorImage = "";
  String vendorAddress = "";
  String vendorCity = "";
  String vendorCountry = "";
  String title = "";
  String contractType = "";
  String coefficient = "";
  DateTime startDate = DateTime.now();
  String roleDescription = "";
  String hoursPerWeek = "";
  bool isActive = true;
  DateTime createdAt = DateTime.now();
  double vendorLat = 0.0;
  double vendorLng = 0.0;

  JobModel();

  JobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    vendorId = json['vendorId'] ?? "";
    vendorName = json['vendorName'] ?? "";
    vendorImage = json['vendorImage'] ?? "";
    vendorAddress = json['vendorAddress'] ?? "";
    vendorCity = json['vendorCity'] ?? "";
    vendorCountry = json['vendorCountry'] ?? "";
    title = json['title'] ?? "";
    contractType = json['contractType'] ?? "";
    coefficient = json['coefficient'] ?? "";
    startDate = json['startDate'] != null
        ? DateTime.parse(json['startDate'])
        : DateTime.now();
    roleDescription = json['roleDescription'] ?? "";
    hoursPerWeek = json['hoursPerWeek'] ?? "";
    isActive = json['isActive'] ?? true;
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    vendorLat = (json['vendorLat'] ?? 0.0).toDouble();
    vendorLng = (json['vendorLng'] ?? 0.0).toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'vendorImage': vendorImage,
      'vendorAddress': vendorAddress,
      'vendorCity': vendorCity,
      'vendorCountry': vendorCountry,
      'title': title,
      'contractType': contractType,
      'coefficient': coefficient,
      'startDate': startDate.toIso8601String(),
      'roleDescription': roleDescription,
      'hoursPerWeek': hoursPerWeek,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'vendorLat': vendorLat,
      'vendorLng': vendorLng,
    };
  }
}