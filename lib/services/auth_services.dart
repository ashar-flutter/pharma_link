import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/config/supportFunctions.dart';
import 'package:linkpharma/models/user_model.dart';
import 'package:linkpharma/page/auth/login_page.dart';
import 'package:linkpharma/services/firestore_services.dart';
import 'package:linkpharma/services/local_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final AuthServices I = AuthServices._();
  AuthServices._();

  Future<String> emailSignIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      UserCredential fbUser = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (fbUser.user != null) {
        currentUser.id = fbUser.user!.uid;
        return "";
      }
      return "error";
    } on FirebaseAuthException catch (error) {
      logger.e(error);
      return SupportFunctions.I.getFirebaseErrorMessage(error.code);
    }
  }

  Future<String> emailSignUp(
    BuildContext context,
    String email,
    password,
  ) async {
    try {
      UserCredential fbUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (fbUser.user != null) {
        currentUser.id = fbUser.user!.uid;
        currentUser.loginType = "mail";
        return "";
      }
      return "Failed to Sign Up";
    } on FirebaseAuthException catch (error) {
      logger.e(error);
      return SupportFunctions.I.getFirebaseErrorMessage(error.code);
    }
  }

  Future<String> sendEmailVarification() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      return "";
    } on FirebaseAuthException catch (error) {
      logger.e(error);
      return SupportFunctions.I.getFirebaseErrorMessage(error.code);
    }
  }

  static bool emailVarification() {
    try {
      return FirebaseAuth.instance.currentUser!.emailVerified;
    } on FirebaseAuthException catch (error) {
      logger.e(error);
      EasyLoading.showError(
        SupportFunctions.I.getFirebaseErrorMessage(error.code),
      );
      return false;
    }
  }

  Future<void> forgetPassword(BuildContext context, String mail) async {
    try {
      await _auth.sendPasswordResetEmail(email: mail);
      EasyLoading.showSuccess("Password reset email sent");
    } on FirebaseAuthException catch (error) {
      logger.e(error);
      EasyLoading.showError(
        SupportFunctions.I.getFirebaseErrorMessage(error.code),
      );
    }
  }

  Future<String> updatePassword(
    context,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        await logOut();
        Get.offAll(LoginPage());
        return "User not found";
      }
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return "";
    } on FirebaseAuthException catch (error) {
      logger.e(error);
      return SupportFunctions.I.getFirebaseErrorMessage(error.code);
    }
  }

  Future<void> checkUser() async {
    User? fbUser = FirebaseAuth.instance.currentUser;
    if (fbUser != null) {
      bool remeberLogin = LocalStorage.I.getValue(
        LocalStorageKeys.remeberLogin,
        true,
      );
      if (remeberLogin) {
        currentUser = await FirestoreServices.I.getUser(fbUser.uid);
        currentUser.id = fbUser.uid;
        currentUser.email = fbUser.email ?? "";
        if (currentUser.enable == false) {
          await logOut();
          EasyLoading.showInfo(
            "Your account is blocked contact to the support.",
          );
        }
      } else {
        await logOut();
      }
    }
  }

  Future<void> logOut() async {
    await LocalStorage.I.clear();
    await _auth.signOut();
    currentUser = UserModel();
  }

  Future<bool> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    try {
      await googleSignIn.initialize();
      final GoogleSignInAccount account = await googleSignIn.authenticate();
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      currentUser.id = userCredential.user?.uid ?? "";
      currentUser.email = userCredential.user?.email ?? "";
      currentUser.firstName =
          userCredential.user?.displayName?.split(' ')[0] ?? "";
      currentUser.lastName =
          userCredential.user?.displayName?.split(' ').skip(1).join(' ') ?? "";
      currentUser.loginType = "google";
      return true;
    } catch (e) {
      EasyLoading.showError("Google login failed!!");
    }
    return false;
  }

  Future<bool> loginWithApple() async {
    try {
      if (!Platform.isIOS && !Platform.isMacOS) {
        if (kDebugMode) print('Apple Sign-In is only available on iOS/macOS');
      }

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(oauthCredential);

      final user = userCredential.user;
      if (user == null) return false;
      currentUser.id = user.uid;
      currentUser.email = appleCredential.email ?? user.email ?? "";
      currentUser.firstName = appleCredential.givenName ?? "";
      currentUser.lastName = appleCredential.familyName ?? "";
      currentUser.loginType = "apple";
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Apple login failed: $e');
      }
      EasyLoading.showError("Apple login failed!!");
    }
    return false;
  }

  Future<bool> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      if (result.status != LoginStatus.success) {
        if (kDebugMode) {
          print('Facebook login failed: ${result.status} ${result.message}');
        }
        return false;
      }
      final userData = await FacebookAuth.instance.getUserData(
        fields: 'id,name,email,picture.width(400).height(400)',
      );
      currentUser.id = (userData['id'] ?? '').toString();
      currentUser.email = (userData['email'] ?? '').toString();
      currentUser.firstName = (userData['name'] ?? '').toString();
      currentUser.lastName = "";
      currentUser.loginType = "facebook";
      return true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Facebook sign-in PlatformException: ${e.code} ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Facebook sign-in error: $e');
      }
    }
    return false;
  }
}
