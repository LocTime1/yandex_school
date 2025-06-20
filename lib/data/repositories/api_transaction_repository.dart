// lib/data/repositories/api_transaction_repository.dart

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
    final data = await _api.get('/transactions/account/$accountId/period', {
      'from': from.toUtc().toIso8601String(),
      'to': to.toUtc().toIso8601String(),
    });
    return (data as List<dynamic>)
        .map((e) => AppTransaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
