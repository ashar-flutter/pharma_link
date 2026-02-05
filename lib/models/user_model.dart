class UserModel {
  String id = "";
  String firstName = ""; // pharmacist name
  String description = "";
  String city = "";
  String email = "";
  String language = "en";
  String loginType = "email";
  int userType = 1;
  String rpps = "";

  // User
  String lastName = "";
  String image = "";
  String phone = "";
  String role = "";
  String cv = "";
  bool enable = true;
  String experience = "";

  // Pharmacy
  String address = "";
  String country = "";
  String zipCode = "";
  String siret = "";
  List<String> images = [];
  List<String> services = [];


  double latitude = 0.0;
  double longitude = 0.0;


  List<Map<String, dynamic>> schedule = [
    {"isOpen": true, "start": "08:30", "end": "19:00"}, // Mo
    {"isOpen": true, "start": "08:30", "end": "19:00"}, // Tu
    {"isOpen": true, "start": "08:30", "end": "19:00"}, // We
    {"isOpen": true, "start": "08:30", "end": "19:00"}, // Th
    {"isOpen": true, "start": "08:30", "end": "19:00"}, // Fr
    {"isOpen": false, "start": "Closed", "end": ""}, // Sa
    {"isOpen": false, "start": "Closed", "end": ""}, // Su
  ];

  List<Map<String, dynamic>> owners = []; // {id, name, image, surname}
  List<String> pharmacies = []; // pharmacy_ids

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    description = json['description'];
    city = json['city'];
    email = json['email'];
    language = json['language'];
    loginType = json['loginType'];
    userType = json['userType'];
    rpps = json['rpps'];
    lastName = json['lastName'];
    image = json['image'];
    phone = json['phone'];
    role = json['role'];
    cv = json['cv'];
    enable = json['enable'];
    experience = json['experience'];
    address = json['address'];
    country = json['country'];
    zipCode = json['zipCode'];
    siret = json['siret'];
    images = List<String>.from(json['images']);
    services = List<String>.from(json['services']);



    latitude = (json['latitude'] ?? 0.0).toDouble();
    longitude = (json['longitude'] ?? 0.0).toDouble();


    //  SCHEDULE FIX: Proper loading
    schedule = List<Map<String, dynamic>>.from(json['schedule'] ?? [
      {"isOpen": true, "start": "08:30", "end": "19:00"},
      {"isOpen": true, "start": "08:30", "end": "19:00"},
      {"isOpen": true, "start": "08:30", "end": "19:00"},
      {"isOpen": true, "start": "08:30", "end": "19:00"},
      {"isOpen": true, "start": "08:30", "end": "19:00"},
      {"isOpen": false, "start": "Closed", "end": ""},
      {"isOpen": false, "start": "Closed", "end": ""},
    ]);

    owners = List<Map<String, dynamic>>.from(json['owners']);
    pharmacies = List<String>.from(json['pharmacies']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['description'] = description;
    data['city'] = city;
    data['email'] = email;
    data['language'] = language;
    data['loginType'] = loginType;
    data['userType'] = userType;
    data['rpps'] = rpps;
    data['lastName'] = lastName;
    data['image'] = image;
    data['phone'] = phone;
    data['role'] = role;
    data['cv'] = cv;
    data['enable'] = enable;
    data['experience'] = experience;
    data['address'] = address;
    data['country'] = country;
    data['zipCode'] = zipCode;
    data['siret'] = siret;
    data['images'] = images;
    data['services'] = services;

    data['schedule'] = schedule;

    data['owners'] = owners;
    data['pharmacies'] = pharmacies;

    data["latitude"]=latitude;
    data["longitude"]=longitude;

    return data;
  }
}