import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class MockTransactionRepository implements TransactionRepository {
  final List<AppTransaction> _txs = [];

  @override
  Future<List<AppTransaction>> getAllTransactions() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.of(_txs);
  }

  @override
  Future<AppTransaction> getTransactionById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _txs.firstWhere((t) => t.id == id);
  }

  @override
  Future<AppTransaction> createTransaction(AppTransaction t) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final newTx = t.copyWith(
      id: DateTime.now().millisecondsSinceEpoch, 
      createdAt: DateTime.now(), 
      updatedAt: DateTime.now(),
    );
    _txs.add(newTx);
    return newTx;
  }

  @override
  Future<AppTransaction> updateTransaction(AppTransaction t) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final i = _txs.indexWhere((e) => e.id == t.id);
    if (i != -1) {
      final updated = t.copyWith(updatedAt: DateTime.now());
      _txs[i] = updated;
      return updated;
    }
    throw Exception('Transaction not found');
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _txs.removeWhere((e) => e.id == id);
  }
}
