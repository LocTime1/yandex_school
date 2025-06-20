import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'data/datasources/api_client.dart';
import 'data/repositories/api_bank_account_repository.dart';
// import 'data/repositories/mock_bank_account_repository.dart';
// import 'data/repositories/mock_transaction_repository.dart';
// import 'domain/repositories/bank_account_repository.dart';
// import 'domain/repositories/transaction_repository.dart';
import 'data/repositories/api_category_repository.dart';
import 'data/repositories/api_transaction_repository.dart';
import 'domain/repositories/bank_account_repository.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/repositories/transaction_repository.dart';
import 'ui/screens/home_screen.dart';
// import 'domain/repositories/category_repository.dart';
// import 'data/repositories/mock_category_repository.dart';

void main() async {
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
        Provider<BankAccountRepository>(
          create: (ctx) => ApiBankAccountRepository(ctx.read<ApiClient>()),
        ),
        ChangeNotifierProvider<ValueNotifier<int>>(
          create: (_) => ValueNotifier<int>(0),
        ),
        Provider<CategoryRepository>(
          create: (ctx) => ApiCategoryRepository(ctx.read<ApiClient>()),
        ),
        Provider<TransactionRepository>(
          create: (ctx) => ApiTransactionRepository(ctx.read<ApiClient>()),
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
    return MaterialApp(title: "Yandex Homework", home: HomeScreen());
  }
}
