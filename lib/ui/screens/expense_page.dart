import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/entities/category.dart';
// import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/category_repository.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final txRepo  = context.read<TransactionRepository>();
    final catRepo = context.read<CategoryRepository>();
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        // txRepo.getAllTransactions(),
        catRepo.getAllCategories(),
      ]),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError || snap.data == null) {
          return Center(child: Text('Ошибка: ${snap.error}'));
        }
        final allTx   = snap.data![0] as List<AppTransaction>;
        final allCats = snap.data![1] as List<Category>;
        final expenses = allTx.where((t) => t.amount < 0).toList();
        return ListView.separated(
            itemCount: expenses.length + 1,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              if (i == 0) {
                final total = expenses.fold<double>(
                  0, (sum, t) => sum + t.amount.abs(),
                );
                return Container(
                  color: const Color.fromRGBO(212, 250, 230, 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Text(
                        'Всего',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        '${total.toStringAsFixed(0)} ₽',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }
              final tx = expenses[i - 1];
              final cat = allCats.firstWhere((c) => c.id == tx.categoryId);
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading:
                  cat.emoji.isNotEmpty
                      ? CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: Text(
                          cat.emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      )
                      : null,
              minLeadingWidth: 0,
              horizontalTitleGap: 0,
                title: Text(cat.name),
                subtitle: tx.comment.isNotEmpty ? Text(tx.comment) : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${tx.amount.abs().toStringAsFixed(0)} ₽',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 24),
                  ],
                ),
                onTap: () {

                },
              );
            },
          
        );
      },
    );
  }
}
