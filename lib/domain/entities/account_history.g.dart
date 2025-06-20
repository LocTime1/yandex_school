// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountHistory _$AccountHistoryFromJson(Map<String, dynamic> json) =>
    _AccountHistory(
      id: (json['id'] as num).toInt(),
      accountId: (json['accountId'] as num).toInt(),
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      event: json['event'] as String,
    );

Map<String, dynamic> _$AccountHistoryToJson(_AccountHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'balance': instance.balance,
      'currency': instance.currency,
      'createdAt': instance.createdAt.toIso8601String(),
      'event': instance.event,
    };
