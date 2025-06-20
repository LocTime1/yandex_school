
import 'package:flutter/material.dart';

class HomeFab extends StatelessWidget {
  final int idx;
  const HomeFab(this.idx);

  @override
  Widget build(BuildContext context) {
    if (idx >= 3) return const SizedBox.shrink();
    return RawMaterialButton(
      onPressed: () {},
      fillColor: const Color(0xFF2AE881),
      constraints: const BoxConstraints.tightFor(width: 70, height: 70),
      shape: const CircleBorder(),
      elevation: 4,
      child: const Icon(Icons.add, size: 40, color: Colors.white),
    );
  }
}

