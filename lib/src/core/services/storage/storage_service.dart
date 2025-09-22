abstract class StorageService {
  Future<String> getData({required String key});
  Future<bool> hasData({required String key});
  Future<void> setData({required String key, required String data});
  Future<void> deleteData({required String key});
}
