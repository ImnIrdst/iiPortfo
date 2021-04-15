import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String KEY_NOBITEX_FILE_PATH = "key_nobitex_file_path";

  static Future<void> saveNobitexFilePath(String filePath) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(KEY_NOBITEX_FILE_PATH, filePath);
  }

  static Future<String> getNobitexFilePath() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(KEY_NOBITEX_FILE_PATH);
  }
}
