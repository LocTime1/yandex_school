import '../../domain/entities/bank_account.dart';
import '../../domain/repositories/bank_account_repository.dart';
import '../../domain/entities/account_history.dart';

class MockBankAccountRepository implements BankAccountRepository {
  final _history = <AccountHistory>[];
  final _accounts = <BankAccount>[
    BankAccount(
      id: 1,
      userId: 1,
      name: 'Основной счёт',
      balance: 1000.00,
      currency: 'RUB',
      createdAt: DateTime.parse('2025-06-13T07:39:10.644Z'),
      updatedAt: DateTime.parse('2025-06-13T07:39:10.644Z'),
    ),
  ];

  @override
  Future<List<BankAccount>> getAllAccounts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.of(_accounts);
  }

  @override
  Future<BankAccount> getAccountById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _accounts.firstWhere((a) => a.id == id);
  }

  @override
  Future<void> updateAccount(BankAccount account) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final i = _accounts.indexWhere((a) => a.id == account.id);
    if (i != -1) {
      _accounts[i] = account;
    }
    final now = DateTime.now();
    _history.add(
      AccountHistory(
        id: now.millisecondsSinceEpoch,
        accountId: account.id,
        balance: account.balance,
        currency: account.currency,
        createdAt: now,
        event: 'Обновлён счёт',
      ),
    );
  }

  @override
  Future<BankAccount> createAccount({
    required String name,
    required double balance,
    required String currency,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final newId =
        (_accounts.map((a) => a.id).fold<int>(0, (m, e) => e > m ? e : m)) + 1;
    final now = DateTime.now();
    final account = BankAccount(
      id: newId,
      userId: 1,
      name: name,
      balance: balance,
      currency: currency,
      createdAt: now,
      updatedAt: now,
    );
    _accounts.add(account);
    return account;
  }

  @override
  Future<List<AccountHistory>> getAccountHistory(int accountId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _history.where((h) => h.accountId == accountId).toList();
  }
}
