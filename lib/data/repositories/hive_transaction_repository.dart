import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/hive_transaction_ds.dart';
import 'api_transaction_repository.dart';

class HiveTransactionRepository implements TransactionRepository {
  final HiveTransactionDataSource _local;
  final ApiTransactionRepository _remote;

  HiveTransactionRepository(this._local, this._remote);

  @override
  Future<List<AppTransaction>> getTransactionsByAccountPeriod({
    required int accountId,
    required DateTime from,
    required DateTime to,
  }) async {
    final remoteList = await _remote.getTransactionsByAccountPeriod(
      accountId: accountId,
      from: from,
      to: to,
    );
    await _local.boxClearAndPutAll(remoteList);
    return remoteList;
  }

  @override
  Future<AppTransaction> getTransactionById(int id) async {
    final localTx = await _local.getById(id);
    if (localTx != null) return localTx;
    final remoteTx = await _remote.getTransactionById(id);
    await _local.put(remoteTx);
    return remoteTx;
  }

  @override
  Future<AppTransaction> createTransaction(AppTransaction t) async {
    final created = await _remote.createTransaction(t);
    await _local.put(created);
    return created;
  }

  @override
  Future<AppTransaction> updateTransaction(AppTransaction t) async {
    final updated = await _remote.updateTransaction(t);
    await _local.put(updated);
    return updated;
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await _remote.deleteTransaction(id);
    await _local.delete(id);
  }
}
