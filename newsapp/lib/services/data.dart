import 'package:newsapp/model/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = [];
  CategoryModel categoryModel = CategoryModel(categoryName: '');

  categoryModel.categoryName = "Business";
  category.add(categoryModel);
  categoryModel = CategoryModel(categoryName: '');

  categoryModel.categoryName = "Entertainment";
  category.add(categoryModel);
  categoryModel = CategoryModel(categoryName: '');

  categoryModel.categoryName = "General";
  category.add(categoryModel);
  categoryModel = CategoryModel(categoryName: '');

  categoryModel.categoryName = "Health";
  category.add(categoryModel);
  categoryModel = CategoryModel(categoryName: '');

  categoryModel.categoryName = "Sports";
  category.add(categoryModel);
  categoryModel = CategoryModel(categoryName: '');

  return category;
}
