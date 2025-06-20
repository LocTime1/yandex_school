import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> titles;
  final int idx;

  const HomeAppBar({required this.titles, required this.idx});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titles[idx]),
      centerTitle: true,
      backgroundColor: const Color(0xFF00FE81),
      actions: _buildActions(idx),
    );
  }

  List<Widget> _buildActions(int idx) {
    switch (idx) {
      case 0:
      case 1:
        return [ _AppBarIcon(icon: Icons.history, onPressed: () {}) ];
      case 2:
        return [ _AppBarIcon(icon: Icons.edit,    onPressed: () {}) ];
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

  const _AppBarIcon({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: const EdgeInsets.only(right: 15),
      icon: Icon(icon, color: Colors.grey[800], size: 30),
    );
  }
}
