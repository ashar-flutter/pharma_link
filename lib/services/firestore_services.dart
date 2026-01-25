import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/models/user_model.dart';

class FirestoreServices {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static final FirestoreServices I = FirestoreServices._();
  FirestoreServices._();

  Future<UserModel> getUser(String id) async {
    DocumentSnapshot doc = await _instance.collection("users").doc(id).get();
    if (!doc.exists) {
      return UserModel();
    }
    UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    logger.i(user.toJson());
    return user;
  }

  Future<void> addUser(UserModel user) async {
    await _instance.collection("users").doc(user.id).set(user.toJson());
  }
}
