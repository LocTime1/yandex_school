import 'package:hive/hive.dart';
import '../../domain/entities/bank_account.dart';

class HiveBankAccountDataSource {
  static const _boxName = 'bank_accounts';

  Future<Box<BankAccount>> _openBox() =>
    Hive.openBox<BankAccount>(_boxName);

  Future<List<BankAccount>> getAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<BankAccount?> getById(int id) async {
    final box = await _openBox();
    return box.get(id);
  }

  Future<void> put(BankAccount acc) async {
    final box = await _openBox();
    await box.put(acc.id, acc);
  }

  Future<void> delete(int id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}
