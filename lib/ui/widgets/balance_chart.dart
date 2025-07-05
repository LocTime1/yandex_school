import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/selected_account.dart';
import '../../domain/repositories/transaction_repository.dart';

class BalanceChart extends StatefulWidget {
  const BalanceChart({Key? key}) : super(key: key);

  @override
  State<BalanceChart> createState() => _BalanceChartState();
}

class _BalanceChartState extends State<BalanceChart> {
  bool _byMonth = false;
  List<BarChartGroupData> _bars = [];
  List<String> _labels = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reload();
  }

  Future<void> _reload() async {
    final acc = context.read<SelectedAccountNotifier>().account;
    if (acc == null) return;

    final now = DateTime.now();
    final from =
        _byMonth
            ? DateTime(now.year, now.month - 11, 1)
            : now.subtract(const Duration(days: 29));

    final txs = await context
        .read<TransactionRepository>()
        .getTransactionsByAccountPeriod(accountId: acc.id, from: from, to: now);

    final map = <String, double>{};
    if (_byMonth) {
      for (int i = 11; i >= 0; i--) {
        final d = DateTime(now.year, now.month - i, 1);
        map['${d.month.toString().padLeft(2, '0')}.${d.year % 100}'] = 0;
      }
      for (var tx in txs) {
        final key =
            '${tx.transactionDate.month.toString().padLeft(2, '0')}.${tx.transactionDate.year % 100}';
        map[key] = (map[key] ?? 0) + tx.amount;
      }
    } else {
      for (int i = 29; i >= 0; i--) {
        final d = now.subtract(Duration(days: i));
        map['${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}'] =
            0;
      }
      for (var tx in txs) {
        final key =
            '${tx.transactionDate.day.toString().padLeft(2, '0')}.${tx.transactionDate.month.toString().padLeft(2, '0')}';
        map[key] = (map[key] ?? 0) + tx.amount;
      }
    }

    final bars = <BarChartGroupData>[];
    final labels = <String>[];
    int idx = 0;
    map.forEach((lbl, sum) {
      labels.add(lbl);
      bars.add(
        BarChartGroupData(
          x: idx++,
          barRods: [
            BarChartRodData(
              toY: sum.abs(),
              color: sum >= 0 ? Colors.green : Colors.red,
              width: 8,
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        ),
      );
    });

    setState(() {
      _bars = bars;
      _labels = labels;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_bars.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final maxY = _bars.map((b) => b.barRods.first.toY).reduce(max) * 1.1;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          CupertinoSegmentedControl<bool>(
            selectedColor: Color.fromRGBO(42, 232, 129, 1),
            borderColor: Color.fromRGBO(42, 232, 129, 1),
            groupValue: _byMonth,
            children: const {
              false: Padding(
                padding: EdgeInsets.all(6),
                child: Text('По дням'),
              ),
              true: Padding(
                padding: EdgeInsets.all(6),
                child: Text('По месяцам'),
              ),
            },
            onValueChanged: (v) {
              setState(() => _byMonth = v);
              _reload();
            },
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                barGroups: _bars,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: Colors.black12),
                    left: BorderSide(color: Colors.transparent),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i == 0 ||
                            i == _labels.length ~/ 2 ||
                            i == _labels.length - 1) {
                          return Text(
                            _labels[i],
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = _labels[group.x.toInt()];
                      final val = rod.toY.toStringAsFixed(0);
                      return BarTooltipItem(
                        '$label\n$val ₽',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                maxY: maxY,
                minY: 0,
              ),
              swapAnimationDuration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }
}
