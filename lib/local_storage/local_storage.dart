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

  ///
}
