import 'package:hive/hive.dart';
import '../../domain/entities/category.dart';

class HiveCategoryDataSource {
  static const _boxName = 'categories';

  Future<Box<Category>> _openBox() => Hive.openBox<Category>(_boxName);

  Future<List<Category>> loadAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> saveAll(List<Category> list) async {
    final box = await _openBox();
    await box.clear();
    for (final c in list) {
      await box.put(c.id, c);
    }
  }

  Future<void> put(Category c) async {
    final box = await _openBox();
    await box.put(c.id, c);
  }

  Future<void> delete(int id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}
