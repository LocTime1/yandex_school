import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@HiveType(typeId: 0)
@freezed
abstract class Category with _$Category {
  const factory Category({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required String emoji,
    @HiveField(3) @JsonKey(name: 'isIncome') required bool isIncome,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
