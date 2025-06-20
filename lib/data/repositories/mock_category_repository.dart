import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class MockCategoryRepository implements CategoryRepository {
  final _all = [
    const Category(id: 1, name: 'Аренда квартиры', emoji: '🏠', isIncome: false),
    const Category(id: 2, name: 'Одежда', emoji: '👗', isIncome: false),
    const Category(id: 3, name: 'На собачку', emoji: '🐶', isIncome: false),
    const Category(id: 4, name: 'Ремонт квартиры', emoji: '🔧', isIncome: false),
    const Category(id: 5, name: 'Продукты', emoji: '🍭', isIncome: false),
    const Category(id: 6, name: 'Спортзал', emoji: '🏋️', isIncome: false),
    const Category(id: 7, name: 'Медицины', emoji: '💊', isIncome: false),
    const Category(id: 8, name: 'Зарплата', emoji: '', isIncome: true),
    const Category(id: 9, name: 'Подработка', emoji: '', isIncome: true),
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
