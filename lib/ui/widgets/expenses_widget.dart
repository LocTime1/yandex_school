// import 'package:flutter/material.dart';



// /// Виджет списка расходов с шапкой «Всего»
// class ExpensesList extends StatelessWidget {
//   final double total;
//   final List<ExpenseStat> stats;
//   final void Function(int index)? onItemTap;

//   const ExpensesList({
//     Key? key,
//     required this.total,
//     required this.stats,
//     this.onItemTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Цвет, похожий на макет (светло-зеленый)
//     const headerColor = Color.fromRGBO(212, 250, 230, 1);

//     return Column(
//       children: [
//         // Шапка «Всего»
//         Container(
//           color: headerColor,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Row(
//             children: [
//               const Text(
//                 'Всего',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//               const Spacer(),
//               Text(
//                 '${total.toStringAsFixed(0)} ₽',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Собственно список
//         Expanded(
//           child: ListView.separated(
//             itemCount: stats.length,
//             separatorBuilder: (_, __) => const Divider(height: 1),
//             itemBuilder: (context, index) {
//               final s = stats[index];
//               return ListTile(
//                 leading: CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Colors.transparent,
//                   child: Text(s.emoji, style: const TextStyle(fontSize: 20)),
//                 ),
//                 title: Text(s.name, style: const TextStyle(fontSize: 16)),
//                 subtitle: s.subtitle == null
//                     ? null
//                     : Text(s.subtitle!, style: const TextStyle(fontSize: 14)),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       '${s.amount.toStringAsFixed(0)} ₽',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(width: 8),
//                     const Icon(Icons.chevron_right, size: 24),
//                   ],
//                 ),
//                 onTap: onItemTap == null ? null : () => onItemTap!(index),
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
