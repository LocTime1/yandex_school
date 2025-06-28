import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/hive_category_ds.dart';
import 'api_category_repository.dart';

class HiveCategoryRepository implements CategoryRepository {
  final HiveCategoryDataSource _local;
  final ApiCategoryRepository _remote;

  HiveCategoryRepository(this._local, this._remote);

  @override
  Future<List<Category>> getAllCategories() async {
    final localCats = await _local.loadAll();
    if (localCats.isNotEmpty) {
      _syncInBackground();
      return localCats;
    }
    final remoteCats = await _remote.getAllCategories();
    await _local.saveAll(remoteCats);
    return remoteCats;
  }

  @override
  Future<List<Category>> getExpenseCategories() async {
    final all = await getAllCategories();
    return all.where((c) => !c.isIncome).toList();
  }

  @override
  Future<List<Category>> getIncomeCategories() async {
    final all = await getAllCategories();
    return all.where((c) => c.isIncome).toList();
  }

  void _syncInBackground() async {
    try {
      final fresh = await _remote.getAllCategories();
      await _local.saveAll(fresh);
    } catch (_) {}
  }
}
