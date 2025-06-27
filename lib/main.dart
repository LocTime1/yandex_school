import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/api_client.dart';
import 'data/repositories/api_category_repository.dart';
import 'data/repositories/api_transaction_repository.dart';

import 'data/datasources/hive_category_ds.dart';
import 'data/repositories/hive_category_repository.dart';
import 'data/datasources/hive_transaction_ds.dart';
import 'data/repositories/hive_transaction_repository.dart';

import 'data/datasources/hive_bank_account_ds.dart';
import 'data/repositories/hive_bank_account_repository.dart';

import 'domain/repositories/category_repository.dart';
import 'domain/repositories/transaction_repository.dart';
import 'domain/repositories/bank_account_repository.dart';

import 'domain/entities/category.dart';
import 'domain/entities/transaction.dart';
import 'domain/entities/bank_account.dart';

import 'ui/screens/home_screen.dart';

import 'data/repositories/api_bank_account_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(AppTransactionAdapter());
  Hive.registerAdapter(BankAccountAdapter());
  const apiKey = 'EJoa94ip1xgDPzUavksNaKce';
  final apiClient = ApiClient(
    httpClient: http.Client(),
    baseUrl: 'https://shmr-finance.ru/api/v1',
    apiKey: apiKey,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        Provider<CategoryRepository>(
          create:
              (_) => HiveCategoryRepository(
                HiveCategoryDataSource(),
                ApiCategoryRepository(apiClient),
              ),
        ),
        Provider<TransactionRepository>(
          create:
              (_) => HiveTransactionRepository(
                HiveTransactionDataSource(),
                ApiTransactionRepository(apiClient),
              ),
        ),
        Provider<BankAccountRepository>(
          create:
              (ctx) => HiveBankAccountRepository(
                HiveBankAccountDataSource(),
                ApiBankAccountRepository(ctx.read<ApiClient>()),
              ),
        ),
        ChangeNotifierProvider<ValueNotifier<int>>(
          create: (_) => ValueNotifier<int>(0),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yandex Homework',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}



