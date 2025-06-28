import 'package:hive/hive.dart';
import '../../domain/entities/transaction.dart';

class HiveTransactionDataSource {
  static const _boxName = 'transactions';

  Future<Box<AppTransaction>> _openBox() =>
      Hive.openBox<AppTransaction>(_boxName);

  Future<List<AppTransaction>> getAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> put(AppTransaction tx) async {
    final box = await _openBox();
    await box.put(tx.id, tx);
  }

  Future<void> delete(int id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<AppTransaction?> getById(int id) async {
    final box = await _openBox();
    return box.get(id);
  }

  Future<void> boxClearAndPutAll(List<AppTransaction> list) async {
    final box = await _openBox();
    await box.clear();
    for (var tx in list) {
      await box.put(tx.id, tx);
    }
  }
}
