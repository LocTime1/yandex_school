import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class MockCategoryRepository implements CategoryRepository {
  final _all = [
    const Category(id: 1, name: 'Еда',    emoji: '🍔', isIncome: false),
    const Category(id: 2, name: 'Зарплата', emoji: '💰', isIncome: true),
  ];

  @override
  Future<List<Category>> getAllCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.of(_all);
  }

  @override
  Future<List<Category>> getExpenseCategories() async =>
    _all.where((c) => !c.isIncome).toList();

  @override
  Future<List<Category>> getIncomeCategories() async =>
    _all.where((c) => c.isIncome).toList();
}
