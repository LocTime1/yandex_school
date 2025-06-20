import '../../domain/entities/account_history.dart';
import '../../domain/entities/bank_account.dart';
import '../../domain/repositories/bank_account_repository.dart';
import '../datasources/api_client.dart';

class ApiBankAccountRepository implements BankAccountRepository {
  final ApiClient _api;

  ApiBankAccountRepository(this._api);

  @override
  Future<List<BankAccount>> getAllAccounts() async {
    final raw = await _api.get('/accounts');

    late final List<dynamic> list;
    if (raw is List) {
      list = raw;
    } else if (raw is Map<String, dynamic> && raw['accounts'] is List) {
      list = raw['accounts'] as List<dynamic>;
    } else {
      throw Exception(
        'Непредвиденный формат данных для getAllAccounts: ${raw.runtimeType}',
      );
    }

    return list
        .map((e) => BankAccount.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BankAccount> getAccountById(int id) async {
    final data = await _api.get('/accounts/$id');
    return BankAccount.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<BankAccount> createAccount({
    required String name,
    required double balance,
    required String currency,
  }) async {
    final body = {
      'name': name,
      'balance': balance.toStringAsFixed(2),
      'currency': currency,
    };
    final data = await _api.post('/accounts', body);
    return BankAccount.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> updateAccount(BankAccount account) async {
    final body = {
      'name': account.name,
      'balance': account.balance.toStringAsFixed(2),
      'currency': account.currency,
    };
    await _api.put('/accounts/${account.id}', body);
  }

  @override
  Future<List<AccountHistory>> getAccountHistory(int accountId) async {
    final data = await _api.get('/accounts/$accountId/history');
    return (data as List<dynamic>)
        .map((e) => AccountHistory.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
