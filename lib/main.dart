import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/mock_bank_account_repository.dart';
import 'data/repositories/mock_transaction_repository.dart';
import 'domain/repositories/bank_account_repository.dart';
import 'domain/repositories/transaction_repository.dart';
import 'ui/screens/home_screen.dart';
import 'domain/repositories/category_repository.dart';
import 'data/repositories/mock_category_repository.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ValueNotifier<int>>(
          create: (_) => ValueNotifier<int>(0),
        ),
        Provider<CategoryRepository>(
          create: (_) => MockCategoryRepository(),
        ),
        Provider<BankAccountRepository>(create: (_) => MockBankAccountRepository()),
         Provider<TransactionRepository>(
          create: (_) => MockTransactionRepository(),
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Yandex Homework",
      home: HomeScreen()
    );
  }
}
