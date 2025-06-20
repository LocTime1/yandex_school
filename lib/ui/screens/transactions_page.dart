import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../widgets/transactions_list.dart';

enum TransactionType { expense, income }

class TransactionsPage extends StatelessWidget {
  final TransactionType type;
  final int accountId;

  const TransactionsPage({
    Key? key,
    required this.type,
    required this.accountId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));

    final txRepo = context.read<TransactionRepository>();
    final catRepo = context.read<CategoryRepository>();

    return FutureBuilder<List<AppTransaction>>(
      future: txRepo.getTransactionsByAccountPeriod(
        accountId: accountId,
        from: from,
        to: to,
      ),
      builder: (ctx, txSnap) {
        if (txSnap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (txSnap.hasError || txSnap.data == null) {
          print("Ошибка транзакций: ${txSnap.error}");
          return const Center(child: CircularProgressIndicator());
        }
        final allTx = txSnap.data!;

        return FutureBuilder<List<Category>>(
          future: catRepo.getAllCategories(),
          builder: (ctx2, catSnap) {
            if (catSnap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (catSnap.hasError || catSnap.data == null) {
              print('Ошибка категорий: ${catSnap.error}');
              return const Center(child: CircularProgressIndicator());
            }
            final allCats = catSnap.data!;
            final ops =
                allTx.where((tx) {
                  final category = allCats.firstWhere(
                    (c) => c.id == tx.categoryId,
                  );
                  return type == TransactionType.expense
                      ? !category.isIncome
                      : category.isIncome;
                }).toList();
            final total = ops.fold<double>(0, (sum, tx) => sum + tx.amount);
            return TransactionsList(
              total: total,
              items: ops,
              categories: allCats,
              onTap: (tx) {},
            );
          },
        );
      },
    );
  }
}
