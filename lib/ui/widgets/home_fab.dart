import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/selected_account.dart';
import '../../core/models/transaction_type.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../screens/transaction_edit_screen.dart';

class HomeFab extends StatelessWidget {
  final int idx;
  final VoidCallback? onTransactionAdded;

  const HomeFab(this.idx, {Key? key, this.onTransactionAdded})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (idx != 0 && idx != 1) return const SizedBox.shrink();

    return Consumer<SelectedAccountNotifier>(
      builder: (context, selectedAcc, child) {
        final acc = selectedAcc.account;
        if (acc == null) return const SizedBox.shrink();

        final type =
            idx == 0 ? TransactionType.expense : TransactionType.income;

        return RawMaterialButton(
          onPressed: () {
            Navigator.of(context)
                .push<AppTransaction>(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder:
                        (_) => TransactionEditScreen(editing: null, type: type),
                  ),
                )
                .then((result) async {
                  if (result != null) {
                    await context
                        .read<TransactionRepository>()
                        .createTransaction(result);
                    onTransactionAdded?.call();
                  }
                });
          },
          fillColor: Theme.of(context).colorScheme.primary,
          constraints: const BoxConstraints.tightFor(width: 70, height: 70),
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, size: 40, color: Colors.white),
        );
      },
    );
  }
}
