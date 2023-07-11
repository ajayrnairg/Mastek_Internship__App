import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rough_app/src/features/screens/home_screen/home_screen.dart';
import 'package:rough_app/src/features/screens/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helperfunctions/sharedpref_helper.dart';
import 'database.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future getCurrentUser() async {
    return await auth.currentUser;
  }

  Future signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    if (result != null) {
      User userDetails = result.user!;
      SharedPreferenceHelper().saveUserEmail(userDetails.email);
      SharedPreferenceHelper().saveUserId(userDetails.uid);
      SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL);
      SharedPreferenceHelper().saveDisplayName(userDetails.displayName);
      SharedPreferenceHelper()
          .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));

      Map<String, dynamic> userInfoMap = {
        "displayname": userDetails.displayName,
        "email": userDetails.email,
        "id": userDetails.uid,
        "profileURL": userDetails.photoURL,
        "username": userDetails.email?.replaceAll("@gmail.com", ""),
      };

      DatabaseMethods()
          .addGoogleUserInfoToDB(userDetails.uid, userInfoMap)
          .then((value) {
        print("data added to DB");
        Get.offAll(() => const HomeScreen());
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }
  }

  Future signInWithEmailPassword(String emailId, String passwordText) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
        email: emailId, password: passwordText);

    if (result != null) {
      User userDetails = result.user!;

      Map<String, dynamic>? userInfoMap =
          await DatabaseMethods().getUserById(userDetails.uid);

      // print("${userInfoMap.toString()}");
      // print(userInfoMap?["displayname"]);
      final displayName = userInfoMap?["displayname"];

      SharedPreferenceHelper().saveUserEmail(userDetails.email);
      SharedPreferenceHelper().saveUserId(userDetails.uid);
      SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL);
      SharedPreferenceHelper().saveDisplayName(displayName);
      SharedPreferenceHelper()
          .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));

      // print("showing display name");
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // print(prefs.getString("USERDISPLAYNAMEKEY"));
    }
  }

  Future signUpWithEmailPassword(BuildContext context, String displayName,
      String emailId, String passwordText) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
        email: emailId, password: passwordText);

    if (result != null) {
      User userDetails = result.user!;
      Map<String, dynamic> userInfoMap = {
        "displayname": displayName,
        "email": userDetails.email,
        "id": userDetails.uid,
        "profileURL": userDetails.photoURL,
        "username": userDetails.email?.replaceAll("@gmail.com", ""),
      };
      // print("${userInfoMap.toString()}");

      DatabaseMethods()
          .addGoogleUserInfoToDB(userDetails.uid, userInfoMap)
          .then((value) {
        print("data added to DB");
        Get.to(()=>const LogInScreen());
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => LogInScreen()));
      });
    }
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
  }
}
