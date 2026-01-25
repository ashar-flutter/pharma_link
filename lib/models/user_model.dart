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

  List<Map<String, dynamic>> schedule = [
    {"start": null, "end": null}, // Mo
    {"start": null, "end": null}, // Tu
    {"start": null, "end": null}, // We
    {"start": null, "end": null}, // Th
    {"start": null, "end": null}, // Fr
    {"start": null, "end": null}, // Sa
    {"start": null, "end": null}, // Su
  ];
  List<Map<String, dynamic>> owners = []; // {id, name, image, surename}
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
    schedule = List<Map<String, dynamic>>.from(json['schedule']);
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
    return data;
  }
}
