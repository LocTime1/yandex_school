import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/hive_transaction_ds.dart';
import '../datasources/backup_ds.dart';
import 'api_transaction_repository.dart';

class OfflineException implements Exception {
  final List<AppTransaction> localData;
  OfflineException(this.localData);
}

class TransactionRepositoryImpl implements TransactionRepository {
  final HiveTransactionDataSource _local;
  final ApiTransactionRepository _remote;
  final BackupDataSource _backup;

  TransactionRepositoryImpl({
    required HiveTransactionDataSource local,
    required ApiTransactionRepository remote,
    required BackupDataSource backup,
  }) : _local = local,
       _remote = remote,
       _backup = backup;

  @override
  Future<List<AppTransaction>> getTransactionsByAccountPeriod({
    required int accountId,
    required DateTime from,
    required DateTime to,
  }) async {
    await _backup.syncPending(_remote, _local);

    try {
      final remoteList = await _remote.getTransactionsByAccountPeriod(
        accountId: accountId,
        from: from,
        to: to,
      );
      await _local.boxClearAndPutAll(remoteList);
      return remoteList;
    } catch (_) {
      final all = await _local.getAll();
      final filtered =
          all.where((tx) {
            return tx.accountId == accountId &&
                !tx.transactionDate.isBefore(from) &&
                !tx.transactionDate.isAfter(to);
          }).toList();
      throw OfflineException(filtered);
    }
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
    await _local.put(t);
    await _backup.addCreateOperation(t);

    try {
      final created = await _remote.createTransaction(t);

      await _local.delete(t.id);

      await _local.put(created);

      await _backup.removeCreateOperation(t.id);

      return created;
    } catch (_) {
      return t;
    }
  }

  @override
  Future<AppTransaction> updateTransaction(AppTransaction t) async {
    await _local.put(t);
    await _backup.addUpdateOperation(t);

    try {
      final updated = await _remote.updateTransaction(t);
      await _local.put(updated);
      await _backup.removeUpdateOperation(t.id);
      return updated;
    } catch (_) {
      return t;
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await _local.delete(id);
    await _backup.addDeleteOperation(id);

    try {
      await _remote.deleteTransaction(id);
      await _backup.removeDeleteOperation(id);
    } catch (_) {}
  }
}
