import 'package:flutter/foundation.dart' show ChangeNotifier;
import '../../core/models/transaction_type.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class AnalysisModel extends ChangeNotifier {
  final TransactionRepository txRepo;
  final CategoryRepository catRepo;
  final TransactionType type;
  final int accountId;

  AnalysisModel({
    required this.txRepo,
    required this.catRepo,
    required this.type,
    required this.accountId,
  }) {
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month - 1, now.day, 0, 0, 0);
    endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    _load();
  }

  late DateTime startDate;
  late DateTime endDate;

  bool isLoading = false;
  String? error;
  List<AppTransaction> _all = [];
  List<Category> _cats = [];

  Map<Category, List<AppTransaction>> get grouped {
    final Map<int, List<AppTransaction>> tmp = {};
    for (final t in _all) {
      final cat = _cats.firstWhere((c) => c.id == t.categoryId);
      if ((type == TransactionType.expense && cat.isIncome) ||
          (type == TransactionType.income && !cat.isIncome)) {
        continue;
      }
      tmp.putIfAbsent(cat.id, () => []).add(t);
    }
    final result = <Category, List<AppTransaction>>{};
    for (final entry in tmp.entries) {
      final cat = _cats.firstWhere((c) => c.id == entry.key);
      result[cat] = entry.value;
    }
    return result;
  }

  double get total {
    return grouped.values.fold(
      0.0,
      (sum, txs) => sum + txs.fold(0.0, (s, t) => s + t.amount.abs()),
    );
  }

  Future<void> _load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      _all = await txRepo.getTransactionsByAccountPeriod(
        accountId: accountId,
        from: startDate,
        to: endDate,
      );
      _cats = await catRepo.getAllCategories();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePeriod({DateTime? from, DateTime? to}) async {
    if (from != null) startDate = from.isAfter(endDate) ? endDate : from;
    if (to != null) endDate = to.isBefore(startDate) ? startDate : to;
    await _load();
  }
}
