import 'package:shared_preferences/shared_preferences.dart';

class SharePreferData {
  static Future<void> saveData(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("title value: $value");
    await prefs.setString(key, value);
  }

  static Future<String> loadData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static Future<void> removeData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> saveTitle(String title) async {
    await saveData('title', title);
  }

  static Future<String> loadTitle() {
    return loadData('title');
  }

  static Future<void> saveDetail(String detail) async {
    await saveData('detail', detail);
  }

  static Future<String> loadDetail() {
    return loadData('detail');
  }

  static Future<void> saveAvatar(String avatar) async {
    await saveData('avatar', avatar);
  }

  static Future<String> loadAvatar() {
    return loadData('avatar');
  }

  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

}