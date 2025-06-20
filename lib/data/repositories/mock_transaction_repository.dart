import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class MockTransactionRepository implements TransactionRepository {
  final List<AppTransaction> _txs = [
    AppTransaction(
      id: 1,
      accountId: 1,
      categoryId: 1,
      amount: -100000.0,
      transactionDate: DateTime.parse('2025-06-13T10:00:00.000Z'),
      comment: '',
      createdAt: DateTime.parse('2025-06-13T10:00:00.000Z'),
      updatedAt: DateTime.parse('2025-06-13T10:00:00.000Z'),
    ),
    AppTransaction(
      id: 2,
      accountId: 1,
      categoryId: 2,
      amount: -100000.0,
      transactionDate: DateTime.parse('2025-06-13T11:00:00.000Z'),
      comment: '',
      createdAt: DateTime.parse('2025-06-13T11:00:00.000Z'),
      updatedAt: DateTime.parse('2025-06-13T11:00:00.000Z'),
    ),
    AppTransaction(
      id: 3,
      accountId: 1,
      categoryId: 3,
      amount: -100000.0,
      transactionDate: DateTime.parse('2025-06-13T12:00:00.000Z'),
      comment: 'Джек',
      createdAt: DateTime.parse('2025-06-13T12:00:00.000Z'),
      updatedAt: DateTime.parse('2025-06-13T12:00:00.000Z'),
    ),
    AppTransaction(
      id: 4,
      accountId: 1,
      categoryId: 3,
      amount: -100000.0,
      transactionDate: DateTime.parse('2025-06-13T12:30:00.000Z'),
      comment: 'Энни',
      createdAt: DateTime.parse('2025-06-13T12:30:00.000Z'),
      updatedAt: DateTime.parse('2025-06-13T12:30:00.000Z'),
    ),
    AppTransaction(
      id: 5,
      accountId: 1,
      categoryId: 4,
      amount: -100000.0,
      transactionDate: DateTime.parse('2025-06-13T13:00:00.000Z'),
      comment: '',
      createdAt: DateTime.parse('2025-06-13T13:00:00.000Z'),
      updatedAt: DateTime.parse('2025-06-13T13:00:00.000Z'),
    ),
    AppTransaction(
      id: 6,
      accountId: 1,
      categoryId: 5,
      amount: -100000.0,
      transactionDate: DateTime.parse('2025-06-13T13:30:00.000Z'),
      comment: '',
      createdAt: DateTime.parse('2025-06-13T13:30:00.000Z'),
      updatedAt: DateTime.parse('2025-06-13T13:30:00.000Z'),
    ),
    AppTransaction(
      id: 7,
      accountId: 1,
      categoryId: 6,
      amount: -100000.0,
      transactionDate: DateTime.parse('2025-06-13T14:00:00.000Z'),
      comment: '',
      createdAt: DateTime.parse('2025-06-13T14:00:00.000Z'),
      updatedAt: DateTime.parse('2025-06-13T14:00:00.000Z'),
    ),
    AppTransaction(
      id: 8,
      accountId: 1,
      categoryId: 7,
      amount: -100000.0,
      transactionDate: DateTime.parse('2025-06-13T14:30:00.000Z'),
      comment: '',
      createdAt: DateTime.parse('2025-06-13T14:30:00.000Z'),
      updatedAt: DateTime.parse('2025-06-13T14:30:00.000Z'),
    ),
    AppTransaction(
      id: 9,
      accountId: 1,
      categoryId: 8,
      amount: 500000.0,
      transactionDate: DateTime.parse('2025-06-13T14:30:00.000Z'),
      comment: '',
      createdAt: DateTime.parse('2025-06-13T14:30:00.000Z'),
      updatedAt: DateTime.parse('2025-06-13T14:30:00.000Z'),
    ),
    AppTransaction(
      id: 10,
      accountId: 1,
      categoryId: 9,
      amount: 100000.0,
      transactionDate: DateTime.parse('2025-06-13T14:30:00.000Z'),
      comment: '',
      createdAt: DateTime.parse('2025-06-13T14:30:00.000Z'),
      updatedAt: DateTime.parse('2025-06-13T14:30:00.000Z'),
    ),
  ];

  @override
  Future<List<AppTransaction>> getTransactionsByAccountPeriod({
    required int accountId,
    required DateTime from,
    required DateTime to,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _txs.where((t) {
      return t.accountId == accountId &&
          !t.transactionDate.isBefore(from) &&
          !t.transactionDate.isAfter(to);
    }).toList();
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
