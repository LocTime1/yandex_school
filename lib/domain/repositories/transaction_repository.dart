import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<AppTransaction>> getAllTransactions();
  Future<AppTransaction> getTransactionById(int id);
  Future<AppTransaction> createTransaction(AppTransaction t);
  Future<AppTransaction> updateTransaction(AppTransaction t);
  Future<void> deleteTransaction(int id);
}
