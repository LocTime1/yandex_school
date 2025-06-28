import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@HiveType(typeId: 2)
@freezed
abstract class AppTransaction with _$AppTransaction {
  const factory AppTransaction({
    @HiveField(0) required int id,
    @HiveField(1) required int accountId,
    @HiveField(2) required int categoryId,
    @HiveField(3) required double amount,
    @HiveField(4) required DateTime transactionDate,
    @HiveField(5) required String comment,
    @HiveField(6) required DateTime createdAt,
    @HiveField(7) required DateTime updatedAt,
  }) = _AppTransaction;

  factory AppTransaction.fromJson(Map<String, dynamic> json) =>
      _$AppTransactionFromJson(json);
}
