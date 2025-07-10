import 'package:hive/hive.dart';
import 'operation.dart';

class BackupDataSource {
  static const _boxName = 'pending_ops';
  Future<Box> _open() => Hive.openBox(_boxName);

  Future<void> add(PendingOperation op) async {
    final box = await _open();
    await box.put(op.id, op.toJson());
  }

  Future<List<PendingOperation>> loadAll() async {
    final box = await _open();
    return box.values
        .map((e) => PendingOperation.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<void> remove(String id) async {
    final box = await _open();
    await box.delete(id);
  }
}
