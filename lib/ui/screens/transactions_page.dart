import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/selected_account.dart';
import '../../core/models/transaction_type.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../data/repositories/transaction_repository_impl.dart';
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
      return const Center(child: CircularProgressIndicator());
    }

    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));

    final txRepo = context.read<TransactionRepository>();
    final catRepo = context.read<CategoryRepository>();

    return FutureBuilder<List<Category>>(
      future: catRepo.getAllCategories(),
      builder: (ctxCat, catSnap) {
        if (catSnap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (catSnap.hasError || catSnap.data == null) {
          return const Center(child: Text('Ошибка загрузки категорий'));
        }
        final categories = catSnap.data!;

        return FutureBuilder<List<AppTransaction>>(
          future: txRepo.getTransactionsByAccountPeriod(
            accountId: account.id,
            from: from,
            to: to,
          ),
          builder: (ctxTx, txSnap) {
            if (txSnap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (txSnap.hasError && txSnap.error is OfflineException) {
              final offlineException = txSnap.error as OfflineException;
              final offlineList =
                  offlineException.localData.where((tx) {
                    final cat = categories.firstWhere(
                      (c) => c.id == tx.categoryId,
                    );
                    return type == TransactionType.expense
                        ? !cat.isIncome
                        : cat.isIncome;
                  }).toList();
              final total = offlineList.fold<double>(
                0,
                (sum, tx) => sum + tx.amount,
              );

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.error,
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Text(
                      'Offline mode',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TransactionsList(
                      total: total,
                      items: offlineList,
                      categories: categories,
                      onTap: (tx) {
                        Navigator.of(context)
                            .push<AppTransaction>(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder:
                                    (_) => TransactionEditScreen(
                                      editing: tx,
                                      type: type,
                                    ),
                              ),
                            )
                            .then((updated) {
                              if (updated != null) onChanged?.call();
                            });
                      },
                    ),
                  ),
                ],
              );
            }
            if (txSnap.hasError || txSnap.data == null) {
              return const Center(
                child: Text('Ошибка при загрузке транзакций'),
              );
            }

            final txList = txSnap.data!;
            final filtered =
                txList.where((tx) {
                  final cat = categories.firstWhere(
                    (c) => c.id == tx.categoryId,
                  );
                  return type == TransactionType.expense
                      ? !cat.isIncome
                      : cat.isIncome;
                }).toList();
            final total = filtered.fold<double>(
              0,
              (sum, tx) => sum + tx.amount,
            );

            return TransactionsList(
              total: total,
              items: filtered,
              categories: categories,
              onTap: (tx) {
                Navigator.of(context)
                    .push<AppTransaction>(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder:
                            (_) =>
                                TransactionEditScreen(editing: tx, type: type),
                      ),
                    )
                    .then((updated) {
                      if (updated != null) onChanged?.call();
                    });
              },
            );
          },
        );
      },
    );
  }
}
