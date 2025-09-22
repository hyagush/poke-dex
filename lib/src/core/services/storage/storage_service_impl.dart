import 'package:poke_dex/src/core/services/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServiceImpl implements StorageService {
  @override
  Future<void> deleteData({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<String> getData({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  @override
  Future<bool> hasData({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get(key) != null) return true;
    return false;
  }

  @override
  Future<void> setData({required String key, required String data}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
  }
}
