import 'dart:async';

import '../datasources/backup_ds.dart';
import '../datasources/hive_transaction_ds.dart';
import '../repositories/api_transaction_repository.dart';

class SyncService {
  final BackupDataSource _backup;
  final ApiTransactionRepository _remote;
  final HiveTransactionDataSource _local;
  Timer? _timer;

  SyncService(this._backup, this._remote, this._local) {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => sync());
    sync();
  }

  Future<void> sync() async {
    await _backup.syncPending(_remote, _local);
  }

  void dispose() => _timer?.cancel();
}
