import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_history.freezed.dart';
part 'account_history.g.dart';

@freezed
abstract class AccountHistory with _$AccountHistory {
  const factory AccountHistory({
    required int      id,         
    required int      accountId,  
    required double   balance,    
    required String   currency,   
    required DateTime createdAt,  
    required String   event,      
  }) = _AccountHistory;

  factory AccountHistory.fromJson(Map<String, dynamic> json) =>
      _$AccountHistoryFromJson(json);
}
