import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/selected_account.dart';
import '../../core/models/transaction_type.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../widgets/transactions_list.dart';
import 'transaction_edit_screen.dart';

class TransactionsPage extends StatelessWidget {
  final TransactionType type;
  final VoidCallback? onChanged;

  const TransactionsPage({Key? key, required this.type, this.onChanged})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = context.watch<SelectedAccountNotifier>().account;
    if (account == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));

    final txRepo = context.read<TransactionRepository>();
    final catRepo = context.read<CategoryRepository>();

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        txRepo.getTransactionsByAccountPeriod(
          accountId: account.id,
          from: from,
          to: to,
        ),
        catRepo.getAllCategories(),
      ]),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            body: Center(child: Text('Ошибка: ${snapshot.error}')),
          );
        }

        final allTx = (snapshot.data![0] as List).cast<AppTransaction>();
        final allCats = (snapshot.data![1] as List).cast<Category>();

        final ops =
            allTx.where((tx) {
              try {
                final cat = allCats.firstWhere((c) => c.id == tx.categoryId);
                return type == TransactionType.expense
                    ? !cat.isIncome
                    : cat.isIncome;
              } catch (_) {
                return false;
              }
            }).toList();

        final total = ops.fold<double>(0, (sum, tx) => sum + tx.amount);

        return Scaffold(
          body: TransactionsList(
            total: total,
            items: ops,
            categories: allCats,
            onTap: (tx) {
              Navigator.of(context)
                  .push<AppTransaction>(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder:
                          (_) => TransactionEditScreen(editing: tx, type: type),
                    ),
                  )
                  .then((updated) {
                    if (updated != null) {
                      onChanged?.call();
                    }
                  });
            },
          ),
        );
      },
    );
  }
}
