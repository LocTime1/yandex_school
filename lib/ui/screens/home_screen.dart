import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/models/settings_provider.dart';
import '../../core/models/transaction_type.dart';
import '../../l10n/app_localizations.dart';
import '../screens/transactions_page.dart';
import '../screens/articles_screen.dart';
import '../screens/account_screen.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_fab.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasInternet = true;
  StreamSubscription<List<ConnectivityResult>>? _connSub;

  @override
  void initState() {
    super.initState();
    _connSub = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> statuses,
    ) {
      _checkInternet();
    });
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    bool prev = _hasInternet;
    try {
      final result = await InternetAddress.lookup(
        '8.8.8.8',
      ).timeout(const Duration(seconds: 5));
      _hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      _hasInternet = false;
    }
    if (prev != _hasInternet) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _connSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final _titles = [
      l10n.todayExpenses,
      l10n.todayIncome,
      l10n.account,
      l10n.articles,
      l10n.settings,
    ];
    final nav = context.watch<ValueNotifier<int>>();
    final idx = nav.value;

    final pages = <Widget>[
      TransactionsPage(
        type: TransactionType.expense,
        onChanged: () => setState(() {}),
      ),
      TransactionsPage(
        type: TransactionType.income,
        onChanged: () => setState(() {}),
      ),
      const AccountScreen(),
      const ArticlesScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      appBar: HomeAppBar(titles: _titles, idx: idx),
      body: Column(
        children: [
          if (!_hasInternet)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.error,
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.offlineMode,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Expanded(child: IndexedStack(index: idx, children: pages)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) {
          if (context.read<SettingsProvider>().hapticsEnabled) {
            HapticFeedback.lightImpact();
          }
          context.read<ValueNotifier<int>>().value = i;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.trending_down),
            label: 'Расходы',
          ),
          NavigationDestination(icon: Icon(Icons.trending_up), label: 'Доходы'),
          NavigationDestination(icon: Icon(Icons.calculate), label: 'Счет'),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Статьи',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Настройки',
          ),
        ],
      ),
      floatingActionButton: HomeFab(
        idx,
        onTransactionAdded: () => setState(() {}),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
