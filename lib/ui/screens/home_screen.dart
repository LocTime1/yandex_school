import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_homework_1/ui/screens/expense_page.dart';

import '../../core/models.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  // final int _selectedIndex = 0;
  final _pages = const [
    ExpensesPage(),
    Center(child: Text('Доходы')),
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

  AppBar buildAppBar(int idx) {
    final title = _titles[idx];
    final color = Color.fromRGBO(0, 254, 129, 1);
    List<Widget> actions = [];
    if (idx == 0 || idx == 1) {
      actions = [
        IconButton(
          onPressed: () {},
          padding: EdgeInsets.only(right: 15),
          icon: Icon(Icons.history, color: Colors.grey[800], size: 30),
        ),
      ];
    } else if (idx == 2) {
      actions = [
        IconButton(
          onPressed: () {},
          padding: EdgeInsets.only(right: 15),
          icon: Icon(Icons.edit, color: Colors.grey[800], size: 30),
        ),
      ];
    } else {
      actions = [];
    }
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: color,
      actions: actions,
    );
  }

  RawMaterialButton? _buildFab(int idx) {
    if (idx < 3) {
      return RawMaterialButton(
        onPressed: () {
        },
        fillColor: Color.fromRGBO(42, 232, 129, 1),
        constraints: BoxConstraints.tightFor(
          width: 80.0, 
          height: 80.0,
        ),
        shape: CircleBorder(), 
        child: Icon(
          Icons.add,
          size: 40.0, 
          color: Colors.white,
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<NavModel>();
    final idx = model.selectedIndex;
    return Scaffold(
      appBar: buildAppBar(idx),
      body: IndexedStack(index: idx, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) {
          context.read<NavModel>().setIndex(i);
        },
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
      floatingActionButton: _buildFab(idx),
    );
  }
}
