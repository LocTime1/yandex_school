import '../../domain/entities/bank_account.dart';
import '../../domain/entities/account_history.dart';
import '../../domain/repositories/bank_account_repository.dart';
import '../datasources/hive_bank_account_ds.dart';
import 'api_bank_account_repository.dart';

class HiveBankAccountRepository implements BankAccountRepository {
  final HiveBankAccountDataSource _local;
  final ApiBankAccountRepository _remote;

  HiveBankAccountRepository(this._local, this._remote);

  @override
  Future<List<BankAccount>> getAllAccounts() async {
    final local = await _local.getAll();
    if (local.isNotEmpty) {
      _syncInBackground();
      return local;
    }
    try {
      final remote = await _remote.getAllAccounts();
      for (final acc in remote) {
        await _local.put(acc);
      }
      return remote;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<BankAccount> getAccountById(int id) async {
    final local = await _local.getById(id);
    if (local != null) return local;
    try {
      final remote = await _remote.getAccountById(id);
      await _local.put(remote);
      return remote;
    } catch (_) {
      throw Exception('Не удалось получить счёт #$id');
    }
  }

  @override
  Future<BankAccount> createAccount({
    required String name,
    required double balance,
    required String currency,
  }) async {
    try {
      final created = await _remote.createAccount(
        name: name,
        balance: balance,
        currency: currency,
      );
      await _local.put(created);
      return created;
    } catch (_) {
      throw Exception('Не удалось создать счёт (офлайн)');
    }
  }

  @override
  Future<void> updateAccount(BankAccount account) async {
    await _local.put(account);
    try {
      await _remote.updateAccount(account);
    } catch (_) {}
  }

  @override
  Future<List<AccountHistory>> getAccountHistory(int accountId) async {
    try {
      return await _remote.getAccountHistory(accountId);
    } catch (_) {
      return [];
    }
  }

  void _syncInBackground() async {
    try {
      final fresh = await _remote.getAllAccounts();
      for (final acc in fresh) {
        await _local.put(acc);
      }
    } catch (_) {}
  }
}
