import 'package:analysis_chart/analysis_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/models/selected_account.dart';
import '../../core/models/transaction_type.dart';
import '../models/analysis_model.dart';
import 'history_screen.dart';

class AnalysisScreen extends StatelessWidget {
  final TransactionType type;
  const AnalysisScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final account = context.watch<SelectedAccountNotifier>().account;
    if (account == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return ChangeNotifierProvider<AnalysisModel>(
      create:
          (ctx) => AnalysisModel(
            txRepo: ctx.read(),
            catRepo: ctx.read(),
            type: type,
            accountId: account.id,
          ),
      child: const _AnalysisView(),
    );
  }
}

class _AnalysisView extends StatelessWidget {
  const _AnalysisView();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AnalysisModel>();

    if (model.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (model.error != null) {
      return Center(child: Text('Ошибка: ${model.error}'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Анализ'),
        centerTitle: true,
        leading: BackButton(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Период: начало'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                DateFormat('LLLL yyyy', 'ru').format(model.startDate),
              ),
            ),
            onTap: () => _pickDate(context, model, isStart: true),
          ),
          const Divider(height: 1, thickness: 1),
          ListTile(
            title: const Text('Период: конец'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(DateFormat('LLLL yyyy', 'ru').format(model.endDate)),
            ),
            onTap: () => _pickDate(context, model, isStart: false),
          ),
          const Divider(height: 1, thickness: 1),
          ListTile(
            title: const Text('Сумма'),
            trailing: Text(
              '${model.total.toStringAsFixed(0)} ₽',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            onTap: null,
          ),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: AnalysisChart(
              sections:
                  model.grouped.entries.map((entry) {
                    final cat = entry.key;
                    final txs = entry.value;
                    final sum = txs.fold<double>(
                      0,
                      (s, t) => s + t.amount.abs(),
                    );
                    return AnalysisSection(title: cat.name, value: sum);
                  }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: model.grouped.length,
              itemBuilder: (ctx, i) {
                final cat = model.grouped.keys.elementAt(i);
                final txs = model.grouped[cat]!;

                final sum = txs.fold<double>(0, (s, t) => s + t.amount.abs());
                final percent = ((sum / model.total) * 100).toStringAsFixed(0);

                final sorted = List.of(txs)..sort(
                  (a, b) => b.transactionDate.compareTo(a.transactionDate),
                );
                final lastComment =
                    sorted.isNotEmpty ? sorted.first.comment : '';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(
                      cat.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  title: Text(cat.name),
                  subtitle: Text(lastComment),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$percent%',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text('${sum.toStringAsFixed(0)} ₽'),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, size: 24),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => HistoryScreen(
                              type: model.type,
                              categoryFilter: cat.id,
                            ),
                      ),
                    );
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext ctx,
    AnalysisModel m, {
    required bool isStart,
  }) async {
    final initial = isStart ? m.startDate : m.endDate;
    final picked = await showDatePicker(
      context: ctx,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      await m.updatePeriod(
        from: isStart ? picked : null,
        to: isStart ? null : picked,
      );
    }
  }
}
