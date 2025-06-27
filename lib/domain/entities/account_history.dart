import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'account_history.freezed.dart';
part 'account_history.g.dart';

@HiveType(typeId: 3)
@freezed
abstract class AccountHistory with _$AccountHistory {
  const factory AccountHistory({
    @HiveField(0) required int id,
    @HiveField(1) required int accountId,
    @HiveField(2) required double balance,
    @HiveField(3) required String currency,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) required String event,
  }) = _AccountHistory;

  factory AccountHistory.fromJson(Map<String, dynamic> json) =>
      _$AccountHistoryFromJson(json);
}
