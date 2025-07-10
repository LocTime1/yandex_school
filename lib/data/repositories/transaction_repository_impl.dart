import 'package:uuid/uuid.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/hive_transaction_ds.dart';
import '../datasources/api_client.dart';
import '../datasources/backup_ds.dart';
import '../datasources/operation.dart';
import '../services/sync_service.dart';
import 'api_transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final HiveTransactionDataSource _local;
  final ApiTransactionRepository _remote;
  final BackupDataSource _backup;
  final SyncService _sync;
  final Uuid _uuid = const Uuid();

  TransactionRepositoryImpl({
    required HiveTransactionDataSource local,
    required ApiTransactionRepository remote,
    required BackupDataSource backup,
    required ApiClient apiClient,
  }) : _local = local,
       _remote = remote,
       _backup = backup,
       _sync = SyncService(backup, apiClient);

  @override
  Future<List<AppTransaction>> getTransactionsByAccountPeriod({
    required int accountId,
    required DateTime from,
    required DateTime to,
  }) async {
    final allLocal = await _local.getAll();
    final localFiltered =
        allLocal
            .where(
              (t) =>
                  t.accountId == accountId &&
                  !t.transactionDate.isBefore(from) &&
                  !t.transactionDate.isAfter(to),
            )
            .toList();

    try {
      await _sync.syncPending();
      final remoteList = await _remote.getTransactionsByAccountPeriod(
        accountId: accountId,
        from: from,
        to: to,
      );
      await _local.boxClearAndPutAll(remoteList);
      return remoteList;
    } catch (_) {
      return localFiltered;
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

    final op = PendingOperation(
      id: _uuid.v4(),
      endpoint: '/transactions',
      type: OperationType.create,
      payload: t.toJson(),
    );
    await _backup.add(op);

    _sync.syncPending().catchError((_) {});

    return t;
  }

  @override
  Future<AppTransaction> updateTransaction(AppTransaction t) async {
    await _local.put(t);

    final op = PendingOperation(
      id: _uuid.v4(),
      endpoint: '/transactions/${t.id}',
      type: OperationType.update,
      payload: t.toJson(),
    );
    await _backup.add(op);

    _sync.syncPending().catchError((_) {});

    return t;
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await _local.delete(id);

    final op = PendingOperation(
      id: _uuid.v4(),
      endpoint: '/transactions/$id',
      type: OperationType.delete,
    );
    await _backup.add(op);

    _sync.syncPending().catchError((_) {});
  }
}
