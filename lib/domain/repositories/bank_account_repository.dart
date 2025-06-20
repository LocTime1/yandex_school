import '../entities/bank_account.dart';
import '../entities/account_history.dart';

abstract class BankAccountRepository {
  Future<List<BankAccount>> getAllAccounts();
  Future<BankAccount> getAccountById(int id);
  Future<void> updateAccount(BankAccount account);
  Future<BankAccount> createAccount({
    required String name,
    required double balance,
    required String currency,
  });
  Future<List<AccountHistory>> getAccountHistory(int accountId);
}
