import '../../data/datasources/api_client.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class ApiTransactionRepository implements TransactionRepository {
  final ApiClient _api;

  ApiTransactionRepository(this._api);

  @override
  Future<AppTransaction> getTransactionById(int id) async {
    final data = await _api.get('/transactions/$id');
    return AppTransaction.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<AppTransaction> createTransaction(AppTransaction t) async {
    final body = t.toJson();
    final data = await _api.post('/transactions', body);
    return AppTransaction.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<AppTransaction> updateTransaction(AppTransaction t) async {
    final body = t.toJson();
    final data = await _api.put('/transactions/${t.id}', body);
    return AppTransaction.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await _api.delete('/transactions/$id');
  }

  @override
  Future<List<AppTransaction>> getTransactionsByAccountPeriod({
    required int accountId,
    required DateTime from,
    required DateTime to,
  }) async {
    final raw =
        await _api.get('/transactions/account/$accountId/period', {
              'from': from.toUtc().toIso8601String(),
              'to': to.toUtc().toIso8601String(),
            })
            as List<dynamic>;

    final flat =
        raw.map((item) {
          final m = item as Map<String, dynamic>;
          return <String, dynamic>{
            'id': m['id'] as int,
            'accountId': (m['account'] as Map<String, dynamic>)['id'] as int,
            'categoryId': (m['category'] as Map<String, dynamic>)['id'] as int,
            'amount': double.parse(m['amount'] as String),
            'transactionDate': m['transactionDate'] as String,
            'comment': (m['comment'] as String?) ?? '',
            'createdAt': m['createdAt'] as String,
            'updatedAt': m['updatedAt'] as String,
          };
        }).toList();

    return flat.map((e) => AppTransaction.fromJson(e)).toList();
  }
}
