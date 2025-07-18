import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/bank_account.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../core/models/selected_account.dart';
import '../../core/models/transaction_type.dart';

class TransactionEditScreen extends StatefulWidget {
  final AppTransaction? editing;
  final TransactionType type;

  const TransactionEditScreen({super.key, this.editing, required this.type});

  @override
  State<TransactionEditScreen> createState() => _TransactionEditScreenState();
}

class _TransactionEditScreenState extends State<TransactionEditScreen> {
  late BankAccount _account;
  List<Category> _allCategories = [];

  Category? _category;
  double? _amount;
  late DateTime _date;
  late TimeOfDay _time;
  String? _comment;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      _date = e.transactionDate;
      _time = TimeOfDay.fromDateTime(e.transactionDate);
      _amount = e.amount;
      _comment = e.comment;
    } else {
      _date = DateTime.now();
      _time = TimeOfDay.now();
      _comment = '';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final selected = context.read<SelectedAccountNotifier>().account!;
      final cats = await context.read<CategoryRepository>().getAllCategories();
      setState(() {
        _account = selected;
        _allCategories = cats;
        if (e != null) {
          _category = cats.firstWhere((c) => c.id == e.categoryId);
        }
      });
    });
  }

  Future<void> _pickAccount() async {
    final chosen = await showDialog<BankAccount>(
      context: context,
      builder:
          (_) => SimpleDialog(
            title: const Text('Счёт'),
            children: [
              SimpleDialogOption(
                child: Text(_account.name),
                onPressed: () => Navigator.pop(context, _account),
              ),
            ],
          ),
    );
    if (chosen != null) {
      setState(() => _account = chosen);
      context.read<SelectedAccountNotifier>().setAccount(chosen);
    }
  }

  Future<void> _pickCategory() async {
    final choices = _allCategories.where(
      (c) => widget.type == TransactionType.expense ? !c.isIncome : c.isIncome,
    );
    final chosen = await showDialog<Category>(
      context: context,
      builder:
          (_) => SimpleDialog(
            title: const Text('Статья'),
            children:
                choices
                    .map(
                      (c) => SimpleDialogOption(
                        child: Text('${c.emoji} ${c.name}'),
                        onPressed: () => Navigator.pop(context, c),
                      ),
                    )
                    .toList(),
          ),
    );
    if (chosen != null) {
      setState(() => _category = chosen);
    }
  }

  Future<void> _pickSum() async {
    final input = await showDialog<String>(
      context: context,
      builder: (_) {
        final ctl = TextEditingController(
          text: _amount?.toStringAsFixed(2) ?? '',
        );
        return AlertDialog(
          title: const Text('Сумма'),
          content: TextField(
            controller: ctl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: '0.00'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ctl.text.trim()),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (input != null && input.isNotEmpty) {
      setState(() => _amount = double.tryParse(input.replaceAll(',', '.')));
    }
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() => _date = d);
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _time);
    if (t != null) {
      setState(() => _time = t);
    }
  }

  Future<void> _save() async {
    if (_category == null || _amount == null) {
      await showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Заполните все поля'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ОК'),
                ),
              ],
            ),
      );
      return;
    }

    final dt = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );
    final tx = AppTransaction(
      id: widget.editing?.id ?? 0,
      accountId: _account.id,
      categoryId: _category!.id,
      amount: _amount!,
      transactionDate: dt,
      comment: _comment ?? '',
      createdAt: widget.editing?.createdAt ?? dt,
      updatedAt: DateTime.now(),
    );
    final repo = context.read<TransactionRepository>();
    final saved =
        widget.editing != null
            ? await repo.updateTransaction(tx)
            : await repo.createTransaction(tx);

    Navigator.of(context).pop(saved);
  }

  Future<void> _delete() async {
    if (widget.editing == null) return;
    await context.read<TransactionRepository>().deleteTransaction(
      widget.editing!.id,
    );
    Navigator.of(context).pop(widget.editing);
  }

  @override
  Widget build(BuildContext context) {
    if (_allCategories.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final isEd = widget.editing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEd ? 'Редактировать' : 'Новая операция'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: const CloseButton(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: _save,
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Счёт'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_account.name),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: _pickAccount,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Статья'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _category == null
                      ? ''
                      : '${_category!.emoji} ${_category!.name}',
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: _pickCategory,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Сумма'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_amount == null ? '' : _amount!.toStringAsFixed(2)),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: _pickSum,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Дата'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(DateFormat('dd.MM.yyyy').format(_date)),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: _pickDate,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Время'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_time.format(context)),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: _pickTime,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Комментарий'),
            subtitle: Text(_comment ?? ''),
            onTap: () async {
              final res = await showDialog<String>(
                context: context,
                builder: (_) {
                  final ctl = TextEditingController(text: _comment);
                  return AlertDialog(
                    title: const Text('Комментарий'),
                    content: TextField(
                      controller: ctl,
                      decoration: const InputDecoration(
                        hintText: 'Комментарий',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed:
                            () => Navigator.pop(context, ctl.text.trim()),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
              if (res != null) setState(() => _comment = res);
            },
          ),
          if (isEd) ...[
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: _delete,
                icon: const Icon(Icons.delete),
                label: Text(
                  widget.type == TransactionType.expense
                      ? 'Удалить расход'
                      : 'Удалить доход',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
