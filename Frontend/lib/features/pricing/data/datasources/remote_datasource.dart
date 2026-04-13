import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../../../../core/network/dio_client.dart';

class RemoteDataSource {
  final DioClient client;

  RemoteDataSource(this.client);

  Future<List> getPricing({int page = 1, String query = ''}) async {
    final res = await client.dio.get('/pricing', queryParameters: {
      'page': page,
      'limit': 20,
      'sku': query
    });
    return res.data;
  }

  Future<void> updatePricing(String id, Map body) async {
    await client.dio.put('/pricing/$id', data: body);
  }

  // CSV Upload (From Flutter assets folder)
  Future<void> uploadCSVFromAssets() async {
    final byteData = await rootBundle.load('assets/retail_dynamic_records.csv');
    final bytes = byteData.buffer.asUint8List();

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: 'sample.csv',
      )
    });

    await client.dio.post('/pricing/upload', data: formData);
  }
}