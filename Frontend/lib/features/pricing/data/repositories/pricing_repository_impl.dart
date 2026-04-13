import '../../../../core/network/network_info.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';

class PricingRepositoryImpl {
  final RemoteDataSource remote;
  final LocalDataSource local;
  final NetworkInfo network;

  PricingRepositoryImpl(this.remote, this.local, this.network);

  Future<List> getPricing({int page = 1, String query = ''}) async {
    if (await network.isConnected) {
      final data = await remote.getPricing(page: page, query: query);
      await local.cacheData(data);
      return data;
    } else {
      return await local.getCachedData();
    }
  }

  Future<void> uploadCSV() async {
    if (await network.isConnected) {
      await remote.uploadCSVFromAssets();
    } else {
      throw Exception('No Internet for upload');
    }
  }

  Future<void> uploadCSVFromAssets() async {
    if (await network.isConnected) {
      await remote.uploadCSVFromAssets();
    } else {
      throw Exception('No Internet for upload');
    }
  }

  Future<void> updatePricing(String id, Map body) async {
    if (await network.isConnected) {
      await remote.updatePricing(id, body);
    } else {
      throw Exception('No Internet');
    }
  }
}