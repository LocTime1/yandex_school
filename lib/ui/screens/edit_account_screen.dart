import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/selected_account.dart';
import '../../domain/entities/bank_account.dart';
import '../../domain/repositories/bank_account_repository.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key, required this.accountId});
  final int accountId;

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late Future<BankAccount> _futureAccount;
  final _nameCtrl = TextEditingController();
  String? _selectedCurrency;
  bool _inited = false;

  @override
  void initState() {
    super.initState();
    _futureAccount = context.read<BankAccountRepository>().getAccountById(
      widget.accountId,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(BankAccount acc) async {
    final updated = acc.copyWith(
      name: _nameCtrl.text.trim(),
      currency: _selectedCurrency!,
      updatedAt: DateTime.now(),
    );
    await context.read<BankAccountRepository>().updateAccount(updated);
    context.read<SelectedAccountNotifier>().setAccount(updated);
    Navigator.pop(context);
  }

  Future<void> _delete(BankAccount acc) async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BankAccount>(
      future: _futureAccount,
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError || snap.data == null) {
          return Scaffold(body: Center(child: Text('Ошибка: ${snap.error}')));
        }
        final acc = snap.data!;
        if (!_inited) {
          _nameCtrl.text = acc.name;
          _selectedCurrency = acc.currency;
          _inited = true;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Мой счёт'),
            centerTitle: true,
            backgroundColor: const Color(0xFF00FE81),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => _save(acc),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              Dismissible(
                key: Key(acc.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await _delete(acc);
                },
                child: ListTile(
                  leading: const Icon(Icons.person_outline, size: 28),
                  title: TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: Text(
                    '${acc.balance.toStringAsFixed(0)} ₽',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const Divider(height: 1),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  label: const Text(
                    'Удалить счёт',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _delete(acc),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
