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
    final remote = await _remote.getAllAccounts();
    for (var acc in remote) {
      await _local.put(acc);
    }
    return remote;
  }

  @override
  Future<BankAccount> getAccountById(int id) async {
    final local = await _local.getById(id);
    if (local != null) return local;
    final remote = await _remote.getAccountById(id);
    await _local.put(remote);
    return remote;
  }

  @override
  Future<BankAccount> createAccount({
    required String name,
    required double balance,
    required String currency,
  }) async {
    final newAcc = await _remote.createAccount(
      name: name,
      balance: balance,
      currency: currency,
    );
    await _local.put(newAcc);
    return newAcc;
  }

  @override
  Future<void> updateAccount(BankAccount account) async {
    await _remote.updateAccount(account);
    await _local.put(account);
  }

  @override
  Future<List<AccountHistory>> getAccountHistory(int accountId) async {
    final remote = await _remote.getAccountHistory(accountId);
    return remote;
  }

  void _syncInBackground() async {
    try {
      final fresh = await _remote.getAllAccounts();
      for (var acc in fresh) {
        await _local.put(acc);
      }
    } catch (_) {}
  }
}
