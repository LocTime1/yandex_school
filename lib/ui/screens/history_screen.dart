import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/models/selected_account.dart';
import '../../core/models/transaction_type.dart';
import '../models/history_model.dart';
import '../widgets/transactions_list.dart';
import 'analysis_screen.dart';

class HistoryScreen extends StatelessWidget {
  final TransactionType type;
  final int? categoryFilter;
  const HistoryScreen({super.key, required this.type, this.categoryFilter});

  @override
  Widget build(BuildContext context) {
    final account = context.watch<SelectedAccountNotifier>().account;
    if (account == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return ChangeNotifierProvider<HistoryModel>(
      create:
          (ctx) => HistoryModel(
            txRepo: ctx.read(),
            catRepo: ctx.read(),
            type: type,
            accountId: account.id,
            categoryFilter: categoryFilter,
          ),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HistoryModel>();
    final fmt = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя история'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon:  Icon(
              Icons.calendar_today,
              color: Theme.of(context).colorScheme.onSurface,
              size: 28,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AnalysisScreen(type: model.type),
                ),
              );
            },
          ),
        ],
      ),
      body:
          model.isLoading
              ? const Center(child: CircularProgressIndicator())
              : model.error != null
              ? Center(child: Text('Ошибка: ${model.error}'))
              : Column(
                children: [
                  ListTile(
                    title: const Text('Начало'),
                    tileColor: Theme.of(context).colorScheme.secondary,
                    trailing: Text(fmt.format(model.startDate)),
                    onTap: () => _pickDate(context, model, isStart: true),
                  ),
                  ListTile(
                    title: const Text('Конец'),
                    tileColor: Theme.of(context).colorScheme.secondary,
                    trailing: Text(fmt.format(model.endDate)),
                    onTap: () => _pickDate(context, model, isStart: false),
                  ),
                  ListTile(
                    title: const Text('Сумма'),
                    tileColor: Theme.of(context).colorScheme.secondary,
                    trailing: Text('${model.total.toStringAsFixed(0)} ₽'),
                  ),
                  Expanded(
                    child: TransactionsList(
                      total: model.total,
                      items: model.items,
                      categories: model.categories,
                      showHeader: false,
                    ),
                  ),
                ],
              ),
    );
  }

  Future<void> _pickDate(
    BuildContext ctx,
    HistoryModel model, {
    required bool isStart,
  }) async {
    final initial = isStart ? model.startDate : model.endDate;
    final picked = await showDatePicker(
      context: ctx,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      await model.updatePeriod(
        newStart: isStart ? picked : null,
        newEnd: isStart ? null : picked,
      );
    }
  }
}
