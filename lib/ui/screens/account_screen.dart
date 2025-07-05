import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../core/models/selected_account.dart';
import '../../domain/entities/bank_account.dart';
import '../../domain/repositories/bank_account_repository.dart';
import '../widgets/balance_chart.dart';

const _currencies = <Map<String, String>>[
  {'label': 'Российский рубль ₽', 'code': '₽'},
  {'label': 'Американский доллар \$', 'code': '\$'},
  {'label': 'Евро €', 'code': '€'},
];

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _showBalance = true;
  late final StreamSubscription<AccelerometerEvent> _accelSub;
  DateTime _lastShake = DateTime.now();

  @override
  void initState() {
    super.initState();
    _accelSub = accelerometerEvents.listen(_onAccelerometer);
  }

  void _onAccelerometer(AccelerometerEvent ev) {
    final now = DateTime.now();
    final magnitude = sqrt(ev.x * ev.x + ev.y * ev.y + ev.z * ev.z);
    const threshold = 25.0;
    if (magnitude > threshold &&
        now.difference(_lastShake) > const Duration(milliseconds: 500)) {
      _lastShake = now;
      setState(() => _showBalance = !_showBalance);
    }
  }

  @override
  void dispose() {
    _accelSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BankAccount>>(
      future: context.read<BankAccountRepository>().getAllAccounts(),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Ошибка: ${snap.error}'));
        }
        final accounts = snap.data!;
        if (accounts.isEmpty) {
          return const Center(child: Text('Счёта не найдены'));
        }
        final acc = accounts.first;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<SelectedAccountNotifier>().setAccount(acc);
        });
        return Column(
          children: [
            Material(
              color: const Color(0xFFBDFBE6),
              child: Column(
                children: [
                  _BalanceTile(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Баланс',
                    value: '${acc.balance.toStringAsFixed(0)} ₽',
                    showValue: _showBalance,
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _InfoTile(
                    icon: Icons.currency_ruble,
                    label: 'Валюта',
                    value: acc.currency,
                    onTap: () => _showCurrencyPicker(context, acc),
                  ),
                  const SizedBox(height: 30),
                  const BalanceChart(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCurrencyPicker(BuildContext ctx, BankAccount acc) {
    showModalBottomSheet(
      context: ctx,
      builder:
          (bctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._currencies.map((curr) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Text(
                          curr['code']!,
                          style: const TextStyle(fontSize: 25),
                        ),
                        title: Text(curr['label']!),
                        onTap: () async {
                          final updated = acc.copyWith(currency: curr['code']!);
                          await ctx.read<BankAccountRepository>().updateAccount(
                            updated,
                          );
                          Navigator.pop(bctx);
                          setState(() {});
                        },
                      ),
                      Divider(height: 5),
                    ],
                  );
                }),
                ListTile(
                  tileColor: Colors.red,
                  leading: const Icon(Icons.close, color: Colors.white),
                  title: const Text(
                    'Отмена',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(bctx),
                ),
              ],
            ),
          ),
    );
  }
}

class _BalanceTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool showValue;
  final VoidCallback onTap;

  const _BalanceTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.showValue,
    required this.onTap,
  });

  @override
  State<_BalanceTile> createState() => __BalanceTileState();
}

class __BalanceTileState extends State<_BalanceTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacityAnim = Tween(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    if (!widget.showValue) {
      _ctrl.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _BalanceTile old) {
    super.didUpdateWidget(old);
    if (widget.showValue) {
      _ctrl.stop();
      _ctrl.reset();
    } else {
      if (!_ctrl.isAnimating) _ctrl.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon, size: 28, color: Colors.grey[800]),
      title: Text(widget.label, style: const TextStyle(fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 120,
            height: 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  widget.showValue ? widget.value : '',
                  key: const ValueKey('balance_text'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                FadeTransition(
                  opacity: _opacityAnim,
                  child:
                      widget.showValue
                          ? const SizedBox.shrink()
                          : Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/noise.png'),
                                repeat: ImageRepeat.repeat,
                                opacity: 1,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 24),
        ],
      ),
      onTap: widget.onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: Colors.grey[800]),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 24),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
