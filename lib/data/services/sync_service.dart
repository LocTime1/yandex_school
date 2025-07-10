import '../datasources/backup_ds.dart';
import '../datasources/api_client.dart';
import '../datasources/operation.dart';

class SyncService {
  final BackupDataSource _backup;
  final ApiClient _api;

  SyncService(this._backup, this._api);

  Future<void> syncPending() async {
    final ops = await _backup.loadAll();
    for (final op in ops) {
      try {
        switch (op.type) {
          case OperationType.create:
            await _api.post(op.endpoint, op.payload!);
            break;
          case OperationType.update:
            await _api.put(op.endpoint, op.payload!);
            break;
          case OperationType.delete:
            await _api.delete(op.endpoint);
            break;
        }
        await _backup.remove(op.id);
      } catch (e) {
        rethrow;
      }
    }
  }
}
