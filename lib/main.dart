import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'core/models/selected_account.dart';

import 'data/datasources/api_client.dart';
import 'data/datasources/backup_ds.dart';
import 'data/datasources/hive_category_ds.dart';
import 'data/datasources/hive_transaction_ds.dart';
import 'data/datasources/hive_bank_account_ds.dart';

import 'data/repositories/api_category_repository.dart';
import 'data/repositories/api_transaction_repository.dart';
import 'data/repositories/api_bank_account_repository.dart';

import 'data/repositories/hive_category_repository.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'data/repositories/hive_bank_account_repository.dart';

import 'data/services/sync_service.dart';

import 'domain/repositories/category_repository.dart';
import 'domain/repositories/transaction_repository.dart';
import 'domain/repositories/bank_account_repository.dart';

import 'domain/entities/category.dart';
import 'domain/entities/transaction.dart';
import 'domain/entities/bank_account.dart';

import 'ui/screens/home_screen.dart';

Future<void> main() async {
  await initializeDateFormatting('ru', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(AppTransactionAdapter());
  Hive.registerAdapter(BankAccountAdapter());

  final raw = await rootBundle.loadString('assets/.env');
  final map = <String, String>{};
  for (var line in raw.split('\n')) {
    if (!line.contains('=')) continue;
    final parts = line.split('=');
    map[parts[0]] = parts.sublist(1).join('=');
  }
  final apiKey = map['API_KEY']!;

  final apiClient = ApiClient(
    baseUrl: 'https://shmr-finance.ru/api/v1',
    apiKey: apiKey,
  );

  final backupDs = BackupDataSource();

  final txRepo = TransactionRepositoryImpl(
    local: HiveTransactionDataSource(),
    remote: ApiTransactionRepository(apiClient),
    backup: backupDs,
    apiClient: apiClient,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),

        Provider<SyncService>(create: (_) => SyncService(backupDs, apiClient)),

        Provider<CategoryRepository>(
          create:
              (_) => HiveCategoryRepository(
                HiveCategoryDataSource(),
                ApiCategoryRepository(apiClient),
              ),
        ),

        Provider<TransactionRepository>.value(value: txRepo),

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

        ChangeNotifierProxyProvider<
          BankAccountRepository,
          SelectedAccountNotifier
        >(
          create: (_) => SelectedAccountNotifier(),
          update: (ctx, bankRepo, notifier) {
            final sel = notifier ?? SelectedAccountNotifier();
            if (sel.account == null) {
              bankRepo.getAllAccounts().then((list) {
                if (list.isNotEmpty) sel.setAccount(list.first);
              });
            }
            return sel;
          },
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
      locale: const Locale('ru'),
      home: const HomeScreen(),
    );
  }
}
