import 'package:intl/intl.dart';
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
    final body = <String, dynamic>{
      'accountId': t.accountId,
      'categoryId': t.categoryId,
      'amount': t.amount.toStringAsFixed(2),
      'transactionDate': t.transactionDate.toUtc().toIso8601String(),
      'comment': t.comment,
    };

    final data = await _api.post('/transactions', body);
    return AppTransaction.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<AppTransaction> updateTransaction(AppTransaction t) async {
    final body = <String, dynamic>{
      'accountId': t.accountId,
      'categoryId': t.categoryId,
      'amount': t.amount.toStringAsFixed(2),
      'transactionDate': t.transactionDate.toUtc().toIso8601String(),
      'comment': t.comment,
    };
    final raw =
        await _api.put('/transactions/${t.id}', body) as Map<String, dynamic>;

    final flat = <String, dynamic>{
      'id': raw['id'] as int,
      'accountId': (raw['account'] as Map<String, dynamic>)['id'] as int,
      'categoryId': (raw['category'] as Map<String, dynamic>)['id'] as int,
      'amount': raw['amount'],
      'transactionDate': raw['transactionDate'] as String,
      'comment': (raw['comment'] as String?) ?? '',
      'createdAt': raw['createdAt'] as String,
      'updatedAt': raw['updatedAt'] as String,
    };

    return AppTransaction.fromJson(flat);
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
    final startDate = DateFormat('yyyy-MM-dd').format(from);
    final endDate = DateFormat('yyyy-MM-dd').format(to);

    final raw =
        await _api.get('/transactions/account/$accountId/period', {
              'startDate': startDate,
              'endDate': endDate,
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
