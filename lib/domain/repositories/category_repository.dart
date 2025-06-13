import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();

  Future<List<Category>> getExpenseCategories();

  Future<List<Category>> getIncomeCategories();
}
