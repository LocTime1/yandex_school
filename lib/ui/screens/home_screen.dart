import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_homework_1/ui/screens/transactions_page.dart';

import '../widgets/home_app_bar.dart';
import '../widgets/home_fab.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _pages = const [
    TransactionsPage(type: TransactionType.expense, accountId: 1),
    TransactionsPage(type: TransactionType.income, accountId: 1),
    Center(child: Text('Счет')),
    Center(child: Text('Статьи')),
    Center(child: Text('Настройки')),
  ];
  final _titles = [
    'Расходы сегодня',
    'Доходы сегодня',
    'Счет',
    'Статьи',
    'Настройки',
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<ValueNotifier<int>>();
    final idx = nav.value;
    return Scaffold(
      appBar: HomeAppBar(titles: _titles, idx: idx),
      body: IndexedStack(index: idx, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected:
            (i) => context.read<ValueNotifier<int>>().value = i,
        backgroundColor: Color.fromRGBO(243, 237, 247, 1),
        indicatorColor: Color.fromRGBO(212, 250, 230, 1),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.trending_down),
            selectedIcon: Icon(
              Icons.trending_down,
              color: Color.fromRGBO(42, 232, 129, 1),
            ),
            label: 'Расходы',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up),
            selectedIcon: Icon(
              Icons.trending_up,
              color: Color.fromRGBO(42, 232, 129, 1),
            ),
            label: 'Доходы',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            selectedIcon: Icon(
              Icons.calculate,
              color: Color.fromRGBO(42, 232, 129, 1),
            ),
            label: 'Счет',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(
              Icons.menu_book,
              color: Color.fromRGBO(42, 232, 129, 1),
            ),
            label: 'Статьи',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(
              Icons.settings,
              color: Color.fromRGBO(42, 232, 129, 1),
            ),
            label: 'Настройки',
          ),
        ],
      ),
      floatingActionButton: HomeFab(idx),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

