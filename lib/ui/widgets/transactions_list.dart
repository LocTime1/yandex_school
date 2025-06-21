import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/category.dart';

class TransactionsList extends StatelessWidget {
  final bool showHeader;
  final double total;
  final List<AppTransaction> items;
  final List<Category> categories;
  final void Function(AppTransaction)? onTap;

  const TransactionsList({
    Key? key,
    this.showHeader = true,
    required this.total,
    required this.items,
    required this.categories,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showHeader)
          Container(
            width: double.infinity,
            color: const Color.fromRGBO(212, 250, 230, 1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Всего',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  '${total.toStringAsFixed(0)} ₽',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final tx = items[i];
              final cat = categories.firstWhere((c) => c.id == tx.categoryId);
              return _TransactionTile(tx: tx, cat: cat, onTap: onTap);
            },
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final AppTransaction tx;
  final Category cat;
  final void Function(AppTransaction)? onTap;

  const _TransactionTile({
    Key? key,
    required this.tx,
    required this.cat,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.transparent,
        child: Text(cat.emoji, style: const TextStyle(fontSize: 20)),
      ),
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
      onTap: onTap == null ? null : () => onTap!(tx),
      minLeadingWidth: 0,
      horizontalTitleGap: 0,
    );
  }
}
