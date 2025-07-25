// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountHistory {

@HiveField(0) int get id;@HiveField(1) int get accountId;@HiveField(2) double get balance;@HiveField(3) String get currency;@HiveField(4) DateTime get createdAt;@HiveField(5) String get event;
/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountHistoryCopyWith<AccountHistory> get copyWith => _$AccountHistoryCopyWithImpl<AccountHistory>(this as AccountHistory, _$identity);

  /// Serializes this AccountHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.event, event) || other.event == event));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,balance,currency,createdAt,event);

@override
String toString() {
  return 'AccountHistory(id: $id, accountId: $accountId, balance: $balance, currency: $currency, createdAt: $createdAt, event: $event)';
}


}

/// @nodoc
abstract mixin class $AccountHistoryCopyWith<$Res>  {
  factory $AccountHistoryCopyWith(AccountHistory value, $Res Function(AccountHistory) _then) = _$AccountHistoryCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int id,@HiveField(1) int accountId,@HiveField(2) double balance,@HiveField(3) String currency,@HiveField(4) DateTime createdAt,@HiveField(5) String event
});




}
/// @nodoc
class _$AccountHistoryCopyWithImpl<$Res>
    implements $AccountHistoryCopyWith<$Res> {
  _$AccountHistoryCopyWithImpl(this._self, this._then);

  final AccountHistory _self;
  final $Res Function(AccountHistory) _then;

/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? balance = null,Object? currency = null,Object? createdAt = null,Object? event = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountHistory].
extension AccountHistoryPatterns on AccountHistory {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountHistory() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountHistory value)  $default,){
final _that = this;
switch (_that) {
case _AccountHistory():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountHistory value)?  $default,){
final _that = this;
switch (_that) {
case _AccountHistory() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  int accountId, @HiveField(2)  double balance, @HiveField(3)  String currency, @HiveField(4)  DateTime createdAt, @HiveField(5)  String event)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountHistory() when $default != null:
return $default(_that.id,_that.accountId,_that.balance,_that.currency,_that.createdAt,_that.event);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int id, @HiveField(1)  int accountId, @HiveField(2)  double balance, @HiveField(3)  String currency, @HiveField(4)  DateTime createdAt, @HiveField(5)  String event)  $default,) {final _that = this;
switch (_that) {
case _AccountHistory():
return $default(_that.id,_that.accountId,_that.balance,_that.currency,_that.createdAt,_that.event);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int id, @HiveField(1)  int accountId, @HiveField(2)  double balance, @HiveField(3)  String currency, @HiveField(4)  DateTime createdAt, @HiveField(5)  String event)?  $default,) {final _that = this;
switch (_that) {
case _AccountHistory() when $default != null:
return $default(_that.id,_that.accountId,_that.balance,_that.currency,_that.createdAt,_that.event);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountHistory implements AccountHistory {
  const _AccountHistory({@HiveField(0) required this.id, @HiveField(1) required this.accountId, @HiveField(2) required this.balance, @HiveField(3) required this.currency, @HiveField(4) required this.createdAt, @HiveField(5) required this.event});
  factory _AccountHistory.fromJson(Map<String, dynamic> json) => _$AccountHistoryFromJson(json);

@override@HiveField(0) final  int id;
@override@HiveField(1) final  int accountId;
@override@HiveField(2) final  double balance;
@override@HiveField(3) final  String currency;
@override@HiveField(4) final  DateTime createdAt;
@override@HiveField(5) final  String event;

/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountHistoryCopyWith<_AccountHistory> get copyWith => __$AccountHistoryCopyWithImpl<_AccountHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.event, event) || other.event == event));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accountId,balance,currency,createdAt,event);

@override
String toString() {
  return 'AccountHistory(id: $id, accountId: $accountId, balance: $balance, currency: $currency, createdAt: $createdAt, event: $event)';
}


}

/// @nodoc
abstract mixin class _$AccountHistoryCopyWith<$Res> implements $AccountHistoryCopyWith<$Res> {
  factory _$AccountHistoryCopyWith(_AccountHistory value, $Res Function(_AccountHistory) _then) = __$AccountHistoryCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int id,@HiveField(1) int accountId,@HiveField(2) double balance,@HiveField(3) String currency,@HiveField(4) DateTime createdAt,@HiveField(5) String event
});




}
/// @nodoc
class __$AccountHistoryCopyWithImpl<$Res>
    implements _$AccountHistoryCopyWith<$Res> {
  __$AccountHistoryCopyWithImpl(this._self, this._then);

  final _AccountHistory _self;
  final $Res Function(_AccountHistory) _then;

/// Create a copy of AccountHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? balance = null,Object? currency = null,Object? createdAt = null,Object? event = null,}) {
  return _then(_AccountHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
