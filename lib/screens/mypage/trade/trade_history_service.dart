import 'dart:convert';
import 'dart:io';

import 'trade_history_model.dart';

class TradeService {
  static const String _baseUrl = 'https://boro-backend-production.up.railway.app';

  Future<List<TradeHistoryItem>> fetchTransactions({
    required String role,
    int page = 1,
    int size = 10,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/api/transactions?role=$role&page=$page&size=$size',
    );

    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          '거래내역을 불러오지 못했습니다. (${response.statusCode})',
        );
      }

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>? ?? {};
      final transactions = data['transactions'] as List<dynamic>? ?? const [];

      return transactions
          .map((item) => TradeHistoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } finally {
      client.close(force: true);
    }
  }
}
