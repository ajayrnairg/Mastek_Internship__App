import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String displayNameKey = "USERDISPLAYNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfilePicKey = "USERPROFILEPICKEY";

  //save data
  Future<bool> saveUserName(String? getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (getUserName != null) {
      return prefs.setString(userNameKey, getUserName);
    }else{
      return false;
    }
  }

  Future<bool> saveUserEmail(String? getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (getUserEmail != null) {
      return prefs.setString(userEmailKey, getUserEmail);
    }
    else{
      return false;
    }
  }

  Future<bool> saveUserId(String? getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (getUserId != null) {
      return prefs.setString(userIdKey, getUserId);
    }
    else{
      return false;
    }

  }

  Future<bool> saveDisplayName(String? getDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (getDisplayName != null) {
      return prefs.setString(displayNameKey, getDisplayName);
    }
    else{
      return false;
    }

  }

  Future<bool> saveUserProfileUrl(String? getUserProfileUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (getUserProfileUrl != null) {
      return prefs.setString(userProfilePicKey, getUserProfileUrl);
    }
    else{
      return false;
    }

  }

  //get data
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }

  Future<String?> getUserProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfilePicKey);
  }
}
