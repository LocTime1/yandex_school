import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class AppTransaction with _$AppTransaction {
  const factory AppTransaction({
    required int      id,
    required int      accountId,
    required int      categoryId,
    required double   amount,
    required DateTime transactionDate,
    required String   comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppTransaction;

  factory AppTransaction.fromJson(Map<String, dynamic> json) =>
      _$AppTransactionFromJson(json);
}
