import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<AppTransaction>> getTransactionsByAccountPeriod({
    required int accountId,
    required DateTime from,
    required DateTime to,
  });
  Future<AppTransaction> getTransactionById(int id);
  Future<AppTransaction> createTransaction(AppTransaction t);
  Future<AppTransaction> updateTransaction(AppTransaction t);
  Future<void> deleteTransaction(int id);
}
