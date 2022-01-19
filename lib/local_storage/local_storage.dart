import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();
  //
  static late SharedPreferences prefs;
  //
  static Future<void> initalizationSharedPrefs() async {
    prefs = await _prefs;
  }

  static void setRolePrfs(String role) {
    prefs.setString('roleKey', role);
  }

  static String getRolePrfs() => prefs.getString('roleKey') ?? '';

  // user info
  static void setUserInfoPrfs(Map map) {
    prefs.setString('emailKey', map['email']);
    prefs.setString('numberKey', map['number_comercial']);
    prefs.setString('phoneKey', map['phone']);
    prefs.setString('roleKey', map['role']);
  }

  static String get getEmail => prefs.getString('emailKey') ?? '';
}
