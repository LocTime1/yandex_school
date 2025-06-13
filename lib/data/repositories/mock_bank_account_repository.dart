import '../../domain/entities/bank_account.dart';
import '../../domain/repositories/bank_account_repository.dart';

class MockBankAccountRepository implements BankAccountRepository {
  final _accounts = <BankAccount>[
    BankAccount(
      id:        1,
      userId:    1,
      name:      'Основной счёт',
      balance:   1000.00,
      currency:  'RUB',
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
  }
}
