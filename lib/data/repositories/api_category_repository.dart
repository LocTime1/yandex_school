import '../../data/datasources/api_client.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class ApiCategoryRepository implements CategoryRepository {
  final ApiClient _api;

  ApiCategoryRepository(this._api);

  @override
  Future<List<Category>> getAllCategories() async {
    final data = await _api.get('/categories');
    return (data as List)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
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
}
