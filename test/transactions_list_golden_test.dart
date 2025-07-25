import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yandex_homework_1/l10n/app_localizations.dart';
import 'package:yandex_homework_1/ui/widgets/transactions_list.dart';
import 'package:yandex_homework_1/domain/entities/transaction.dart';
import 'package:yandex_homework_1/domain/entities/category.dart';

void main() {
  testWidgets('TransactionsList golden', (WidgetTester tester) async {
    final categories = [
      Category(id: 100, name: 'Еда', emoji: '🍔', isIncome: false),
      Category(id: 200, name: 'Зарплата', emoji: '💸', isIncome: true),
    ];
    final transactions = [
      AppTransaction(
        id: 1,
        accountId: 1,
        categoryId: 100,
        amount: -500,
        transactionDate: DateTime(2024, 1, 1),
        comment: 'Обед',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      ),
      AppTransaction(
        id: 2,
        accountId: 1,
        categoryId: 200,
        amount: 40000,
        transactionDate: DateTime(2024, 1, 2),
        comment: '',
        createdAt: DateTime(2024, 1, 2),
        updatedAt: DateTime(2024, 1, 2),
      ),
    ];
    final total = transactions.fold<double>(0, (sum, tx) => sum + tx.amount);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.green,
            secondary: Colors.grey,
          ),
        ),
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 200,
            child: TransactionsList(
              showHeader: true,
              total: total,
              items: transactions,
              categories: categories,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(TransactionsList),
      matchesGoldenFile('goldens/transactions_list.png'),
    );
  });
}
