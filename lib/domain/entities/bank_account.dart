import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_account.freezed.dart';
part 'bank_account.g.dart';

double _balanceFromJson(String s) => double.parse(s);

String _balanceToJson(double v) => v.toStringAsFixed(2);

@freezed
abstract class BankAccount with _$BankAccount {
  const factory BankAccount({
    required int id,
    required int userId,
    required String name,
    @JsonKey(
      name: 'balance',
      fromJson: _balanceFromJson,
      toJson:   _balanceToJson,
    )
    required double balance,

    required String currency,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BankAccount;

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);
}
