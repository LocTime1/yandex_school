import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/models/transaction_type.dart';
import '../screens/transactions_page.dart';
import '../screens/articles_screen.dart';
import '../screens/account_screen.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _titles = [
    'Расходы сегодня',
    'Доходы сегодня',
    'Счет',
    'Статьи',
    'Настройки',
  ];
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then((s) {
      setState(() => _isOffline = s == ConnectivityResult.none);
    });
    Connectivity().onConnectivityChanged.listen((s) {
      final offline = s == ConnectivityResult.none;
      if (offline != _isOffline) setState(() => _isOffline = offline);
    });
  }

  @override
  Widget build(BuildContext context) {
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
      const Center(child: Text('Настройки')),
    ];

    return Scaffold(
      appBar: HomeAppBar(titles: _titles, idx: idx),
      body: Column(
        children: [
          if (_isOffline)
            Container(
              width: double.infinity,
              color: Colors.red,
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text(
                'Offline mode',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Expanded(child: IndexedStack(index: idx, children: pages)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected:
            (i) => context.read<ValueNotifier<int>>().value = i,
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
