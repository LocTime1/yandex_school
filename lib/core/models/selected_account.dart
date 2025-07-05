import 'package:flutter/foundation.dart';
import '../../domain/entities/bank_account.dart';

class SelectedAccountNotifier extends ChangeNotifier {
  BankAccount? _account;
  BankAccount? get account => _account;

  void setAccount(BankAccount acc) {
    _account = acc;
    notifyListeners();
  }
}
