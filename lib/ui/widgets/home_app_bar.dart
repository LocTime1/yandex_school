import 'package:flutter/material.dart';
import '../models/history_model.dart';
import '../screens/history_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> titles;
  final int idx;
  final int accountId;

  const HomeAppBar({
    required this.titles,
    required this.idx,
    this.accountId = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titles[idx]),
      centerTitle: true,
      backgroundColor: const Color(0xFF00FE81),
      actions: _buildActions(context, idx),
    );
  }

  List<Widget> _buildActions(BuildContext context, int idx) {
    switch (idx) {
      case 0:
      case 1:
        return [
          _AppBarIcon(
            icon: Icons.history,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => HistoryScreen(
                        type:
                            idx == 0
                                ? TransactionType.expense
                                : TransactionType.income,
                        accountId: accountId,
                      ),
                ),
              );
            },
          ),
        ];
      case 2:
        return [_AppBarIcon(icon: Icons.edit, onPressed: () {})];
      default:
        return [];
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _AppBarIcon({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: const EdgeInsets.only(right: 15),
      icon: Icon(icon, color: Colors.grey[800], size: 30),
    );
  }
}
