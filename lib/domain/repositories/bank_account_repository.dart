import '../entities/bank_account.dart';

abstract class BankAccountRepository {
  Future<List<BankAccount>> getAllAccounts();
  Future<BankAccount> getAccountById(int id);
  Future<void> updateAccount(BankAccount account);
}
