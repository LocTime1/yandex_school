import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'bank_account.freezed.dart';
part 'bank_account.g.dart';

double _balanceFromJson(String s) => double.parse(s);
String _balanceToJson(double v) => v.toStringAsFixed(2);

@HiveType(typeId: 1)
@freezed
abstract class BankAccount with _$BankAccount {
  const factory BankAccount({
    @HiveField(0) required int id,
    @HiveField(1) required int userId,
    @HiveField(2) required String name,

    @HiveField(3)
    @JsonKey(
      name: 'balance',
      fromJson: _balanceFromJson,
      toJson: _balanceToJson,
    )
    required double balance,

    @HiveField(4) required String currency,
    @HiveField(5) required DateTime createdAt,
    @HiveField(6) required DateTime updatedAt,
  }) = _BankAccount;

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);
}
