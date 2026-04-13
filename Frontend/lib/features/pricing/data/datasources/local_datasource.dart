import 'package:hive/hive.dart';

class LocalDataSource {
  Future<void> cacheData(List data) async {
    var box = await Hive.openBox('pricing');
    await box.put('data', data);
  }

  Future<List> getCachedData() async {
    var box = await Hive.openBox('pricing');
    return box.get('data', defaultValue: []);
  }
}