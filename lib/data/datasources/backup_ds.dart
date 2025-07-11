import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/hive_transaction_ds.dart';

enum _OpType { create, update, delete }

class _PendingOp {
  final _OpType type;
  final AppTransaction? transaction;
  final int id;

  _PendingOp.create(this.transaction)
    : type = _OpType.create,
      id = transaction!.id;

  _PendingOp.update(this.transaction)
    : type = _OpType.update,
      id = transaction!.id;

  _PendingOp.delete(this.id) : type = _OpType.delete, transaction = null;
}

class BackupDataSource {
  final List<_PendingOp> _ops = [];

  Future<void> addCreateOperation(AppTransaction t) async {
    _ops.add(_PendingOp.create(t));
  }

  Future<void> removeCreateOperation(int id) async {
    _ops.removeWhere((o) => o.type == _OpType.create && o.id == id);
  }

  Future<void> addUpdateOperation(AppTransaction t) async {
    _ops.add(_PendingOp.update(t));
  }

  Future<void> removeUpdateOperation(int id) async {
    _ops.removeWhere((o) => o.type == _OpType.update && o.id == id);
  }

  Future<void> addDeleteOperation(int id) async {
    _ops.add(_PendingOp.delete(id));
  }

  Future<void> removeDeleteOperation(int id) async {
    _ops.removeWhere((o) => o.type == _OpType.delete && o.id == id);
  }

  Future<void> syncPending(
    TransactionRepository remote,
    HiveTransactionDataSource local,
  ) async {
    final pending = List<_PendingOp>.from(_ops);

    for (final op in pending) {
      try {
        switch (op.type) {
          case _OpType.create:
            final created = await remote.createTransaction(op.transaction!);
            await local.put(created);
            await removeCreateOperation(op.id);
            break;

          case _OpType.update:
            final updated = await remote.updateTransaction(op.transaction!);
            await local.put(updated);
            await removeUpdateOperation(op.id);
            break;

          case _OpType.delete:
            await remote.deleteTransaction(op.id);
            await removeDeleteOperation(op.id);
            break;
        }
      } catch (_) {}
    }
  }
}
