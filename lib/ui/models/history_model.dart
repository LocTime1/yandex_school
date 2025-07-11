import 'package:flutter/foundation.dart' show ChangeNotifier;
import '../../core/models/transaction_type.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class HistoryModel extends ChangeNotifier {
  final TransactionRepository txRepo;
  final CategoryRepository catRepo;
  final TransactionType type;
  final int accountId;
  final int? categoryFilter;

  HistoryModel({
    required this.txRepo,
    required this.catRepo,
    required this.type,
    required this.accountId,
    this.categoryFilter,
  }) {
    final now = DateTime.now();
    endDate = DateTime(now.year, now.month, now.day);
    startDate = DateTime(now.year, now.month - 1, now.day);
    _load();
  }

  late DateTime startDate;
  late DateTime endDate;

  List<AppTransaction> _all = [];
  List<Category> _cats = [];
  bool isLoading = false;
  String? error;

  List<Category> get categories => _cats;

  List<AppTransaction> get items {
    var list = _all.where((t) {
      final cat = _cats.firstWhere((c) => c.id == t.categoryId);
      final okType =
          type == TransactionType.expense ? !cat.isIncome : cat.isIncome;
      return okType;
    });
    if (categoryFilter != null) {
      list = list.where((t) => t.categoryId == categoryFilter);
    }
    return list.toList();
  }

  double get total => items.fold(0, (sum, t) => sum + t.amount);

  Future<void> _load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final rawTx = await txRepo.getTransactionsByAccountPeriod(
        accountId: accountId,
        from: DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0),
        to: DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59),
      );
      _all = rawTx;
      _cats = await catRepo.getAllCategories();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePeriod({DateTime? newStart, DateTime? newEnd}) async {
    if (newStart != null) {
      startDate = newStart.isAfter(endDate) ? endDate : newStart;
    }
    if (newEnd != null) {
      endDate = newEnd.isBefore(startDate) ? startDate : newEnd;
    }
    await _load();
  }
}
